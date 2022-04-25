module Yggdrasil
  class MagicCode
    GENERATOR = ->(_) { SecureRandom.hex(16) }

    def initialize(email, redis: Redis.current, generator: GENERATOR)
      @email = email
      @redis = redis
      @generator = generator
    end

    def validate!(code)
      @redis.get(magic_key) == code
    end

    def generate
      @generator.call(@email).tap { |token|
        @redis.set(magic_key, token, ex: 1.day.to_i)
      }
    end

    private

    def magic_key
      "magic_link:#{@email}"
    end
  end
end
