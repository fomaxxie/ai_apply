class Letter < ApplicationRecord
  belongs_to :profile

  FORMATS = ['short', 'standard (default)', 'long'].freeze
end
