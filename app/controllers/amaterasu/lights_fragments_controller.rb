module Amaterasu
  class LightsFragmentsController < ApplicationController
    layout false

    def show
      @load = session.fetch(:current_load, 20)
      make_progress
    end

    def update
      session[:current_load] = params[:load].to_i
    end

    private

    def make_progress
      Thread.new do
        3.times do |i|
          sleep(0.3)
          ActionCable.server.broadcast(
            "progress",
            {name: "progress:up", amount: i + 1}
          )
        end
      end
    end
  end
end
