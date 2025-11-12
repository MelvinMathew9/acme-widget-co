# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'
require_relative 'offer'

class BuyOneGetOneHalfPrice < Offer
  attr_reader :product_code

  def initialize(product_code)
    @product_code = product_code
  end

  def discount(items)
    eligible_items = items.select { |item| item.code == product_code }
    return BigDecimal('0') if eligible_items.empty?

    product_cost = eligible_items.first.price
    num_discounts = eligible_items.size / 2
    num_discounts * (product_cost / 2)
  end
end
