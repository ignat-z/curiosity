require "test_helper"
require "generators/spacecraft/spacecraft_generator"

class SpacecraftGeneratorTest < Rails::Generators::TestCase
  tests SpacecraftGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination, :create_fake_routes

  test "generator runs without errors" do
    assert_nothing_raised do
      run_generator ["invincible"]

      assert_file "app/controllers/invincible/home_controller.rb" do |content|
        assert_match(/module Invincible/, content)
        assert_match(/class HomeController < ApplicationController/, content)
      end

      assert_file "config/routes.rb" do |content|
        assert_match(/namespace :invincible do/, content)
        assert_match(/resources :home, only: :index/, content)
      end
    end
  end

  def create_fake_routes
    FileUtils.mkdir_p(File.join(destination_root, "config"))
    File.write File.join(destination_root, "config", "routes.rb"), <<~FILE
      Rails.application.routes.draw do
      end
    FILE
  end
end
