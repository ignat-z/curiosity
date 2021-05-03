class SpacecraftGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def create_controller
    create_file "app/controllers/#{file_name}/home_controller.rb", <<~FILE
      module #{class_name}
        class HomeController < ApplicationController
          layout "#{file_name}"
          def index
          end
        end
      end
    FILE
  end

  def create_layout
    create_file "app/views/layouts/#{file_name}.html.erb", <<~FILE
      <!DOCTYPE html>
      <html>
        <head>
          <title>Curiosity</title>
          <%= csrf_meta_tags %>
          <%= csp_meta_tag %>

          <%= javascript_pack_tag '#{file_name}', 'data-turbolinks-track': 'reload' %>
          <%= stylesheet_pack_tag '#{file_name}', 'data-turbolinks-track': 'reload' %>
        </head>

        <body>
          <%= yield %>
        </body>
      </html>
    FILE
  end

  def create_basic_view
    create_file "app/views/#{file_name}/home/index.html.erb", <<~FILE
      <div>
        <h1>#{class_name} Pages</h1>
      </div>
    FILE
  end

  def create_stylesheet
    create_file "app/packs/stylesheets/#{file_name}.scss"
  end

  def create_javascript
    create_file "app/packs/packs/#{file_name}.js", <<~FILE
      require("@rails/ujs").start();
      require("turbolinks").start();
      require("@rails/activestorage").start();
      require("channels");

      import "stylesheets/#{file_name}";
    FILE
  end

  def update_routes
    inject_into_file "config/routes.rb", after: "Rails.application.routes.draw do\n" do
      <<-FILE
  namespace :#{file_name} do
    resources :home, only: :index

    root to: "home#index"
  end

      FILE
    end
  end
end
