require "amaterasu/products_collection"

module Amaterasu
  class CatalogFragmentsController < ApplicationController
    layout false

    def show
      sleep(1)
      @products = ProductsCollection.new.all
    end
  end
end
