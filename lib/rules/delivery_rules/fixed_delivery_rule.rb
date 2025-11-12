# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

class FixedDeliveryRule < DeliveryRule
  def applies_to?(total)
    total >= min_spend && total < max_spend
  end
end
