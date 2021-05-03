require "ffaker"

module Amaterasu
  COUNT = 50
  Product = Class.new(Struct.new(:name, :model, :price, :sku, :quantity, :net_sales, :country, :created_at))

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
          FFaker::Address.country_code,
          ((Date.today - 1.months)..(Date.today + 1.months)).to_a.sample
        )
      }
    end

    def cached
      $cached ||= all
    end
  end
end
