class Instance < ActiveRecord::Base
  has_one :subscription
  belongs_to :region
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
end
