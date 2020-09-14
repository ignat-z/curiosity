module Amaterasu
  class LightsFragmentsController < ApplicationController
    layout false

    def show
      @load = session.fetch(:current_load, 20)
    end

    def update
      session[:current_load] = params[:load].to_i
    end
  end
end
