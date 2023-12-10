class Letter < ApplicationRecord
  belongs_to :profile
  has_many :bios, dependent: destroy
end
