class InstancesController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_instance, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @instances = current_user.instances.all
    respond_with(@instances)
  end

  def show
  end

  def new
    @instance = Instance.new
    @plans = Plan.all
    @plan = Plan.find_by_id(params[:plan]) || @plans.first
    @regions = Region.order(:slug)
    respond_with(@instance, @plans)
  end

  def create
    logger.info instance_params
    #does not make sense, no stripe data given to this point. 
    params.permit!.merge(
      stripe_token: instance_params[:stripeToken]
    )
    @instance = current_user.instances.new(instance_params)
    @instance.subscription = CreateSubscription.call(params)
    #add region to instance
    #@instance.region_slug = region_slug
    @instance.save
    respond_with(@instance)
  end

  # checks that the user does not have 2 instances with the same name.
  def check_hostname
    
  end

  private
    def set_instance
      @instance = current_user.instances.find(params[:id])
    end

    def instance_params
      params[:instance]
    end

    def region_slug
      params[:region]
    end
end
