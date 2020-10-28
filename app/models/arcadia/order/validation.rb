require "active_model"
require "active_support/core_ext/object"
require "active_support/core_ext/hash/slice"

module Arcadia
  module Order
    class Validation < SimpleDelegator
      include ActiveModel::Validations

      ALLOWED_FIELDS = %i[user_name phone_number product_name cost].freeze
      DEFAULT_ATTRIBUTES = Hash[ALLOWED_FIELDS.map { |key| [key, nil] }]

      with_options presence: true do
        validates :user_name
        validates :phone_number
        validates :product_name
        validates :cost, numericality: {greater_than: 100}
      end

      def self.with_valid(attributes)
        attributes.slice(*ALLOWED_FIELDS)
      end

      def self.with_valid_default(attributes)
        DEFAULT_ATTRIBUTES.merge(with_valid(attributes))
      end
    end
  end
end
