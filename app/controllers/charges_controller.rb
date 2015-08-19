class ChargesController < ApplicationController
	respond_to :html

	def new
	  @instance_info = params.dup
	  respond_with(@instance_info)
	end

	def create
	  # Amount in cents
	  @amount = 500

	  customer = Stripe::Customer.create(
	    :email => 'example@stripe.com',
	    :card  => params[:stripeToken]
	  )

	  charge = Stripe::Charge.create(
	    :customer    => customer.id,
	    :amount      => @amount,
	    :description => 'Rails Stripe customer',
	    :currency    => 'usd'
	  )
	  redirect_to instances_path

	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to charges_path
	end  
end
