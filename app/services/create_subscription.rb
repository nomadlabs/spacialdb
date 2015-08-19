class CreateSubscription < ActiveRecord::Base

  def self.call(params)
    # plan is object with data relative to plan, stated in seed.
    plan_id = Plan.find_by_amount(params[:plan]).id
    instance = Instance.find_by_name(params[:instance])
 
    sub = Subscription.new do |s|
      s.plan_id = plan_id
    end

    if sub.save
      ProcessSubscriptionJob.perform_later sub.id
    end

    #return sub
    sub
    
  end
end
