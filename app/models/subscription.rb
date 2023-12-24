class Subscription < ApplicationRecord
  belongs_to :user

  validates :plan, presence: true

  STATUS = ["inactive", "active", "cancelled", "unpaid", "incomplete"].freeze
end
