# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

class DeliveryRule
  attr_reader :min_spend, :max_spend, :charge

  def initialize(min_spend: nil, max_spend: nil, charge: nil)
    @min_spend = min_spend&.to_d
    @max_spend = max_spend&.to_d
    @charge = charge.nil? ? BigDecimal('0') : charge.to_d
  end

  def applies_to?(_subtotal)
    false
  end
end
