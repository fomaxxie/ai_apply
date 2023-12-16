class Profile < ApplicationRecord
  belongs_to :user
  has_many :letters, dependent: :destroy
  has_many :bios, dependent: :destroy

  validates :full_name, presence: true
  validates :desired_position, presence: true
  validates :years_of_experience, presence: true
  validates :email, presence: true
end
