class User < ApplicationRecord
  rolify
  
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  
  attr_accessor :first_name, :last_name

  
  before_validation :set_full_name

  private

  def set_full_name
    if first_name.present? || last_name.present?
      self.full_name = [first_name, last_name].compact.join(" ").strip
    end
  end
end
