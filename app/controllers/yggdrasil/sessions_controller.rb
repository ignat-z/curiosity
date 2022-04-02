module Yggdrasil
  class SessionsController < ApplicationController
    layout false

    def create
      session[:user] = "Exisiting User"

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to yggdrasil_home_index_path }
      end
    end

    def destroy
      session.delete(:user)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to yggdrasil_home_index_path }
      end
    end
  end
end
