Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}

Stripe.api_key = Rails.application.secrets.stripe_secret_key

class EventRetriever
  def call(params)
    return nil if StripeWebhook.exists?(stripe_id: params[:id])
    StripeWebhook.create!(stripe_id: params[:id])
    Stripe::Event.retrieve(params[:id], Stripe.api_key)
  end
end

StripeEvent.event_retriever = EventRetriever.new
