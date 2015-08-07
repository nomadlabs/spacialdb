class Instance < ActiveRecord::Base
  has_one :subscription
  belongs_to :region
end
