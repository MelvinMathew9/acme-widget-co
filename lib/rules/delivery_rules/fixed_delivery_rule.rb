# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'
require_relative 'delivery_rule'

class FixedDeliveryRule < DeliveryRule
  def applies_to?(total)
    return false if min_spend && total < min_spend

    # If max_spend is nil, treat it as unbounded (no upper limit)
    return true if max_spend.nil?

    total < max_spend
  end
end
