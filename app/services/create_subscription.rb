class CreateSubscription < ActiveRecord::Base

  def self.call(params)
    # plan is object with data relative to plan, stated in seed.
    plan = Plan.find_by_amount(params[:plan])
    region = Region.find_by_slug(params[:region])
    instance = Instance.find_by_name(params[:instance][:name])
 
    sub = Subscription.new do |s|
      s.setPlan(plan)
    end

    if sub.save
      ProcessSubscriptionJob.perform_later sub.id
    end

    #return subq
    sub
    
  end
end
