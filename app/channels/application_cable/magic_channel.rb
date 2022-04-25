module ApplicationCable
  class MagicChannel < ActionCable::Channel::Base
    def subscribed
      stream_from "magic"
    end
  end
end
