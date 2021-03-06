class Plan < ActiveRecord::Base
  after_create :create_stripe_plan
  after_update :update_stripe_plan
  after_destroy { |plan| Stripe::Plan.retrieve(plan.id.to_s).delete }

  validates :amount, presence: true
  validates :currency, presence: true
  validates :interval, presence: true
  validates :name, presence: true

  has_many :subscriptions

  private
    def create_stripe_plan
      begin
        Stripe::Plan.create(
          id: self.id.to_s,
          amount: self.amount,
          currency: self.currency,
          interval: self.interval,
          interval_count: self.interval_count,
          name: self.name,
          trial_period_days: self.trial_period_days,
          metadata: self.metadata,
          statement_descriptor: self.statement_descriptor
        )
      rescue Stripe::StripeError => e
        logger.info e.message
      end
    end

    def update_stripe_plan
      begin
        p = Stripe::Plan.retrieve(self.id.to_s)
        p.name = self.name
        p.metadata = self.metadata
        p.statement_descriptor = self.statement_descriptor
        p.save
      rescue Stripe::StripeError => e
        logger.info e.message
        logger.info p
      end
    end
end
