require 'bigdecimal'
require 'bigdecimal/util'

class Offer
  def discount(_items)
    BigDecimal("0")
  end
end
