require "amaterasu/products_collection"

module Amaterasu
  module Wizzard
    class PasswordsController < ApplicationController
      layout "amaterasu"

      def create
        session[:password] = params[:user][:password]

        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to amaterasu_wizzard_finish_index_path }
        end
      end

      def new
      end
    end
  end
end
