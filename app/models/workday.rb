class Workday < ApplicationRecord
  belongs_to :worker
  belongs_to :workplace

  # Default empty hash for the jsonb column
  attribute :healthcheck, :jsonb, default: {}

  # Convenient accessors for common keys inside etc
  store_accessor :healthcheck, :pressure1, :pressure2, :temp1, :temp2, :checkboxes, :alcohol
end
