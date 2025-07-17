class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum status: {
    pending: "pending",
    paid: "paid",
    shipped: "shipped",
    cancelled: "cancelled"
  }

  enum payment_status: {
    unpaid: "unpaid",
    paid: "paid",
    refunded: "refunded"
  }

  enum payment_method: {
    cod: "cod",
    stripe: "stripe",
    paypal: "paypal"
  }
end
