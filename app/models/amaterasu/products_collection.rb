require "ffaker"

module Amaterasu
  COUNT = 15
  Product = Class.new(Struct.new(:name, :model, :price, :sku, :quantity, :net_sales, :country))

  class ProductsCollection
    def all
      Array.new(COUNT) {
        Product.new(
          FFaker::Product.product,
          FFaker::Product.model,
          (10_00..1000_00).to_a.sample,
          FFaker::Code.ean,
          (50..150).to_a.sample,
          (10_000_00..20_000_00).to_a.sample,
          FFaker::Address.country_code
        )
      }
    end
  end
end
