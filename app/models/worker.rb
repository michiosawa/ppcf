class Worker < ApplicationRecord
  belongs_to :company
  validates :name, presence: true
  has_many :workdays, dependent: :destroy

  # Default empty hash for the jsonb column
  attribute :etc, :jsonb, default: {}

  # Convenient accessors for common keys inside etc
  store_accessor :etc, :language, :config

  # Example association if "reference to other model" is a real association
  # belongs_to :some_other_model, optional: true
  # (you would store the id in etc["reference_id"] or better yet make a real foreign key)

  # Scope example
  scope :by_company, ->(company) { where(company: company) }

  before_create :generate_access_token
  # or SecureRandom.urlsafe_base64(20)
  def generate_access_token
    self.access_token = SecureRandom.hex(20)
  end

  # Optional: regenerate token later
  def regenerate_access_token!
    update!(access_token: SecureRandom.hex(20))
  end
end
