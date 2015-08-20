class InstancesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_global, only: [:new, :create, :edit]
  before_action :set_instance, only: [:show, :edit, :update, :destroy]
  before_action :current_region, only: [:show, :edit]
  respond_to :html

  def index
    @instances = current_user.instances.all
    respond_with(@instances)
  end

  def show
    if params[:stripeToken] && @instance[:status] == "unpaid"
      @instance[:status] = "paid"
      @instance.save!
      flash[:notice] = 'You have successfully paid.'
    end
  end

  #get the content of the form to make a new subscription
  def new
    @instance = Instance.new
    respond_with(@instance, @plans)
  end

  def edit
    
  end

  def update
    params.permit(:instance, :region)
    @instance.update_attributes(name: params[:instance][:name], region_id: get_region_id )
    flash[:notice] = 'Instance was successfully updated.'
    redirect_to @instance
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
end