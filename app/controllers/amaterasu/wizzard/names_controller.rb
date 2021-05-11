require "amaterasu/products_collection"

module Amaterasu
  module Wizzard
    class NamesController < ApplicationController
      layout "amaterasu"

      def create
        session[:name] = params[:user][:name]

        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to new_amaterasu_wizzard_email_path }
        end
      end

      def new
        respond_to do |format|
          format.turbo_stream
          format.html
        end
      end
    end
  end
end
