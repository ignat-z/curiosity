module Arcadia
  class HomeController < ApplicationController
    layout "arcadia"
    def index
      @orders = []#Home.index

      ActiveRecord::Base.transaction do 
        o = AR::Order.first.product_name        
        z = AR::User.create!(email: "xxx#{1}@zzz.com")
      end
    end

    def create
      Home.create(attributes: order_params)
      redirect_to arcadia_home_index_path
    end

    private

    def order_params
      params
        .require(:order)
        .permit(%i[user_name phone_number product_name cost])
    end
  end
end
