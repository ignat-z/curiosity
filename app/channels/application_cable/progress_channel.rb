module ApplicationCable
  class ProgressChannel < ActionCable::Channel::Base
    def subscribed
      stream_from "progress"
    end
  end
end
