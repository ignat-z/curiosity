module AR
  class User < AR::ApplicationRecord
    has_many :orders
  end
end
