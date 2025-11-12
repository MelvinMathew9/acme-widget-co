# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

class DeliveryRule
  attr_reader :min_spend, :max_spend, :charge

  # Defaults: min_spend defaults to 0, max_spend is nil which we treat as unbounded
  def initialize(min_spend: '0', max_spend: nil, charge: nil)
    @min_spend = to_decimal_or_zero(min_spend)
    @max_spend = max_spend&.to_d
    @charge = to_decimal_or_zero(charge)
  end

  def applies_to?(_subtotal)
    false
  end

  private

  def to_decimal_or_zero(value)
    value.nil? ? BigDecimal('0') : value.to_d
  end
end
