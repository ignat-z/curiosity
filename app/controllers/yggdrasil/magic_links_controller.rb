module Yggdrasil
  class MagicLinksController < ApplicationController
    layout false

    def show
      @success = false

      if params[:id] == Redis.current.get("magic_link")
        @success = true
        session[:user] = "Exisiting User"
        ActionCable.server.broadcast(
          "magic",
          {name: "magic:authorized", url: request.url.to_s + "?repeat=true"}
        ) unless params[:repeat]
      end

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to yggdrasil_home_index_path }
      end
    end

    def create
      puts params[:email]
      $xtoken ||= SecureRandom.hex(16)
      token = $xtoken

      Redis.current.set("magic_link", token)
      Redis.current.expire("magic_link", 60 * 60 * 24)
      MagicLinksMailer.notification("email@example.com", token).deliver_now

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
