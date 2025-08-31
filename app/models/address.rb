class Address
  include ActiveModel::Model

  attr_accessor :street, :city, :state, :zip

  validates :street, :city, :state, :zip, presence: true
  validates :zip, format: { with: /\A\d{5}(-\d{4})?\z/, message: "must be a valid ZIP code" }
end
