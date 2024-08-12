class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :profiles
  has_many :letters, through: :profiles
  has_many :bios, through: :profiles
  has_one :subscription

  def can_create_letter?
    subscribed? || letters_count < 3
  end

  def can_create_bio?
    subscribed? || bios_count < 3
  end

  private

  def subscribed?
    subscription.present? && subscription.active?
  end
end
