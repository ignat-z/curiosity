module Amaterasu
  class TodayController < ApplicationController
    layout false
    def index
      @today = params[:today] && params[:today].to_date
      @search = params[:search]

      @items = ProductsCollection.new.cached.select { |product|
        case [@today, @search]
        in [nil, nil]
          true
        in [day, nil]
          product.created_at == day
        in [nil, search]
          product.name.downcase.include?(search)
        end
      }
    end
  end
end
