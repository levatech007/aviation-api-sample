class Airport < Sequel::Model
  # many-to-many self-referencial association join table since an Airports's
  # non-stop destination points to another Airport.
  many_to_many :airport_destinations, left_key: :airport_id,
    right_key: :destination_id, join_table: :destinations, class: self
  many_to_many :destination_airport, right_key: :airport_id,
    left_key: :destination_id, join_table: :destinations, class: self
end
