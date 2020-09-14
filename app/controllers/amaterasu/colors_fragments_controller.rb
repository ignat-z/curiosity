module Amaterasu
  class ColorsFragmentsController < ApplicationController
    layout false

    def show
      @colors = bright_color_generator.take(params.fetch(:par_page, 10).to_i)
      @page = params.fetch(:page, 1).to_i
    end

    private

    def bright_color_generator
      Enumerator.new do |y|
        loop do
          h = rand(360)
          s = rand(100)
          l = rand(60..100)
          y << "hsl(#{h}, #{s}%, #{l}%)"
        end
      end
    end
  end
end
