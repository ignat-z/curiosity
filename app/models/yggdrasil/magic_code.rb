module Yggdrasil
  class MagicCode
    def initialize(email)
      @email = email
    end

    def generate
      $result ||= SecureRandom.hex(16)
    end
  end
end
