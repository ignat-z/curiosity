require "amaterasu/products_collection"

module Amaterasu
  class ProductsController < ApplicationController
    layout "amaterasu"

    def index
      @products = ProductsCollection.new.all
    end
  end
end
