class Subscription < ActiveRecord::Base
  belongs_to :plan, polymorphic: true
  belongs_to :instance, polymorphic: true

  include AASM

  aasm column: 'state', skip_validation_on_save: true do
    state :pending, initial: true
    state :processing
    state :active
    state :canceled
    state :errored

    event :process, after: :start_subscription do
      transitions from: :pending, to: :processing
    end

    event :activate do
      transitions from: :processing, to: :active
    end

    event :cancel do
      transitions from: :active, to: :canceled
    end

    event :fail do
      transitions from: [:pending, :processing], to: :errored
    end
  end

  private

  def start_subscription
    StartSubscription.call(self)
  end
end
