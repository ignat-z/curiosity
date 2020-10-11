module Amaterasu
  class ReposController < ApplicationController
    layout "amaterasu"
    def index
    end

    def show
      @repo = card(params[:id])
      render layout: false
    end

    private

    def card(id)
      result = github_request(id)

      OpenStruct.new(
        gravatar_url: result["owner"]["avatar_url"],
        name: result["full_name"],
        description: result["description"],
        created_at: Time.parse(result["created_at"])
      )
    end

    def github_request(repo)
      uri = URI("https://api.github.com/repos/#{repo}")
      request = Net::HTTP::Get.new(uri)
      request["Accept"] = "application/vnd.github.v3+json"
      response = Net::HTTP.new(uri.hostname, uri.port)
      response.use_ssl = true
      JSON.parse(response.request(request).body)
    end
  end
end
