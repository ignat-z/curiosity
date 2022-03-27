module Arcadia
  class Home < Order::Validation
    def self.index(order_class: AR::Order)
      order_class.includes(:user).order(id: :desc)
    end

    def self.create(attributes:, order_class: AR::Order)
      new(order_class.new(with_valid_default(attributes)))
        .tap(&:validate!)
        .tap(&:save!)
    end
  end
end
