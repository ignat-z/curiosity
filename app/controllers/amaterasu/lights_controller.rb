module Amaterasu
  class LightsController < ApplicationController
    layout false

    def show
      cookies[:authenticity_token] = form_authenticity_token
      @load = session.fetch(:current_load, 20)
    end

    def update
      session[:current_load] = params[:load].to_i
    end
  end
end
