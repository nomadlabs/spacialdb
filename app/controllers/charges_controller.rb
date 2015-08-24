class ChargesController < ApplicationController
	before_action :get_instance, only: [:create]
	respond_to :html

	def new
	end

	def create
	  begin
	      # Amount in cents      
	      plan_id = @current_instance.subscription[:plan_id]
	      plan = Plan.find_by(id: plan_id)
	      @amount = plan.amount

	      # retrieve customer 
	      user_id = @current_instance[:user_id]
	      stripe_customer_id = User.find_by(id: user_id)[:stripe_customer_id]
	      customer = Stripe::Customer.retrieve(stripe_customer_id)

	      # retrieve stripe_plan
	      stripe_plan = Stripe::Plan.retrieve(plan_id.to_s)
	      
	      # assign card entered at payment
	      customer.card = params[:stripeToken]

	      # assing chosen plan to customer
	      customer.plan = stripe_plan

	      # update customer
	      customer.save

		  charge = Stripe::Charge.create(
		    :customer    => customer.id,
		    :amount      => @amount,
		    :description => 'SpacialDB Stripe customer',
		    :currency    => 'EUR'
		  )
	  
      rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to instance_path(@current_instance)
        return
      end

      # Update instance from 'upaid' to 'paid'. Only executed if rescue not fired.
	  @current_instance[:status] = "paid"
	  @current_instance.save!
	end  

	private 

	  def get_instance
		params.permit(:instance_id)
		@current_instance = Instance.find_by(id: params[:instance_id])
	  end

end
