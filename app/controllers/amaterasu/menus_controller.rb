module Amaterasu
  class MenusController < ApplicationController
    layout "amaterasu"

    def index
      @today = params.fetch(:today) { Date.today }.to_date
      @dates = ProductsCollection.new.cached.pluck(:created_at).uniq
    end
  end
end
