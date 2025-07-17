class User < ApplicationRecord
  rolify

  has_many :products
  has_many :categories
  has_one :seller_detail, dependent: :destroy
  has_one_attached :display_picture
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessor :first_name, :last_name
  

  private

  def set_full_name
    if first_name.present? || last_name.present?
      self.full_name = [first_name, last_name].compact.join(" ").strip
    end
  end
end
