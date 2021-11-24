class Order < ApplicationRecord
  validates_presence_of :number

  def to_proto
    Rpc::Order.new(
      id: id.to_i,
      number: number.to_s,
      total: total.to_f
    )
  end
end
