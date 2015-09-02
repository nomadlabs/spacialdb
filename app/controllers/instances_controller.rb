class InstancesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_global, only: [:new, :create, :edit]
  before_action :set_instance, only: [:show, :edit, :update, :destroy]
  before_action :current_region, only: [:show, :edit]
  before_action :get_plan, only: [:show, :edit, :update]
  respond_to :html
  helper_method :sort_column, :sort_direction

  def index
    @instances = current_user.instances.all.includes(:region).includes(:subscription).order(sort_column + " " + sort_direction)
    respond_with(@instances)
  end

  def show
  end

  # get the content of the form to make a new subscription
  def new
    @instance = Instance.new
    respond_with(@instance, @plans)
  end

  def edit
  end

  def update
    params.permit(:instance, :region, :plan)
    new_plan_id = Plan.find_by(amount: params[:plan]).id
    if @instance.update_attributes(name: params[:instance][:name], region_id: get_region_id)
      # TODO: When changing plan -> change stripe payment plan.
      # if downsizing, we should check that current_user.occupied_memory <= new_plan.memory
      if @instance.subscription.update_attributes(plan_id: new_plan_id)
        flash[:notice] = 'Instance was successfully updated.'
        redirect_to @instance
      else
        flash[:error] = 'Plan could not be updated.'
        redirect_to edit_instance_path(@instance)
      end
    else
      flash[:error] = 'Hostname not valid.'
      redirect_to edit_instance_path(@instance)
    end
  end

  def create
    logger.info instance_params
    params.permit!.merge(
      stripe_token: params[:stripeToken]
    )
    @instance = current_user.instances.new(instance_params)
    @instance.subscription = CreateSubscription.call(params)
    @instance.status = "unpaid"
    @instance.region_id = get_region_id
    flash[:notice] = 'Instance was successfully created.' if @instance.save
    respond_with(@instance)
  end

  def destroy
    @instance.destroy
    redirect_to instances_path
  end

  private

    def sort_direction
      %w[asc desc].include?(params[:direction])? params[:direction] : "asc"
    end

    def sort_column
      #Instance.column_names.include?(params[:sort]) ? params[:sort] : "name"
      ["name", "status", "regions.name", "subscriptions.plan_id"].include?(params[:sort]) ? params[:sort] : "name"
    end

    # Set global variables on every reload
    def set_global
      @plans = @plans || Plan.all
      @plan = Plan.find_by_id(params[:plan]) || @plans.first
      @regions = Region.order(:slug)
      @region = @regions.first.slug
    end

    def set_instance
      @instance = current_user.instances.find(params[:id])
    end

    def instance_params
      params[:instance]
    end

    def current_region
      @myRegion = Region.find(@instance[:region_id])
    end

    def get_region_id
      leslug = params[:region]
      Region.find_by(slug: leslug).id
    end

    def get_plan
      leplan_id = @instance.subscription.plan_id
      @myPlan = Plan.find_by(id: leplan_id)
    end

end