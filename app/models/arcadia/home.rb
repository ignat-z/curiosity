module Arcadia
  class Home < Order::Validation
    def self.index(order_class: AR::Order)
      x = nil
      z = nil 

      ActiveRecord::Base.transaction do 
        z = AR::User.create!(email: "xxx#{SecureRandom.hex(4)}@zzz.com")
      end

      ActiveRecord::Base.transaction do 
        x = order_class.includes(:user).order(id: :desc)
        z = AR::User.create!(email: "xxx#{SecureRandom.hex(4)}@xxx.com")
        AR::Order.create!(user: z, product_name: SecureRandom.hex(4), cost: rand(1000))
      end
      x
    end

    def self.create(attributes:, order_class: AR::Order)
      new(order_class.new(with_valid_default(attributes)))
        .tap(&:validate!)
        .tap(&:save!)
    end
  end
end
