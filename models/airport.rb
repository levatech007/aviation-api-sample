class Airport < Sequel::Model
  many_to_many :direct_predecessors, left_key: :airport_id,
    right_key: :destination_id, join_table: :destinations, class: self
  many_to_many :direct_successors, right_key: :destination_id,
    left_key: :airport_id, join_table: :destinations, class: self
end
