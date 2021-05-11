require "amaterasu/products_collection"

module Amaterasu
  module Wizzard
    class EmailsController < ApplicationController
      layout "amaterasu"

      def create
        session[:email] = params[:user][:email]

        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to new_amaterasu_wizzard_password_path }
        end
      end

      def new
      end
    end
  end
end
