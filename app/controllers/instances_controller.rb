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
  #get the content of the form to make a new subscription
  def new
    @instance = Instance.new
    @plans = Plan.all
    @plan = Plan.find_by_id(params[:plan]) || @plans.first
    @regions = Region.order(:slug)
    respond_with(@instance, @plans)
  end

  def create 
    #go on and do the subscription
    logger.info instance_params
    #too early: should better be after the checkout
    params.permit!.merge(
      stripe_token: instance_params[:stripeToken]
    )
    
    #instance should better be after the payment
    @instance = current_user.instances.new(instance_params)
    @instance.subscription = CreateSubscription.call(params)
    @instance.region_id = get_region_id
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

    def get_region_id
      theslug = params[:region]
      Region.find_by(slug: theslug).id
    end
end
