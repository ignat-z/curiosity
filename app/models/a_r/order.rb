module AR
  class Order < AR::ApplicationRecord
    belongs_to :user
  end
end
