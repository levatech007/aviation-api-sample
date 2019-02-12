class Airport < Sequel::Model
  many_to_one :parent, class: self
  one_to_many :children, key: :destination_airport_id, class: self
end
