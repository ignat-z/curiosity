module Yggdrasil
  class MagicLinksController < ApplicationController
    layout false

    def show
      @success = MagicCode.new(params[:email]).validate!(params[:id])

      if @success
        session[:user] = params[:email]

        if params[:repeat].nil?
          uri = URI.parse(request.url)
          uri.query = [uri.query, "repeat=true"].join("&")
          ActionCable.server.broadcast(
            "magic",
            {name: "magic:authorized", url: uri.to_s}
          )
        end
      end

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to yggdrasil_home_index_path }
      end
    end

    def create
      token = MagicCode.new(params[:email]).generate
      VisitorMailer.magic_link_requested(params[:email], token).deliver_now

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to yggdrasil_home_index_path }
      end
    end

    def destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to yggdrasil_home_index_path }
      end
    end
  end
end
