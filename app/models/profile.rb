class Profile < ApplicationRecord
  belongs_to :user
  has_many :letters, dependent: destroy
  
end
