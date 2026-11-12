class Company < ApplicationRecord
  has_many :workers, dependent: :destroy
end
