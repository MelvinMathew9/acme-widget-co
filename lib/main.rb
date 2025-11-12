require_relative 'models/product'
require_relative 'rules/delivery_rules/fixed_delivery_rule'
require_relative 'rules/offers/buy_one_get_one_half_price'
require_relative 'basket'

products = [
  Product.new(code: "R01", name: "Red Widget", price: "32.95"),
  Product.new(code: "G01", name: "Green Widget", price: "24.95"),
  Product.new(code: "B01", name: "Blue Widget", price: "7.95")
]

delivery_rules = [
  FixedDeliveryRule.new(max_spend: 50, charge: 4.95),
  FixedDeliveryRule.new(min_spend: 50, max_spend: 90, charge: 2.95),
  FixedDeliveryRule.new(min_spend: 90, charge: 0)
]

offers = [
  BuyOneGetOneHalfPrice.new("R01")
]

basket = Basket.new(catalogue: products, delivery_rules: delivery_rules, offers: offers)
basket.add("B01")
basket.add("B01")
basket.add("R01")
basket.add("R01")
basket.add("R01")

puts "Products in basket:"
basket.items.each do |item|
  puts "- #{item.code} #{item.name}: $#{format('%.2f', item.price)}"
end

puts "Total: $#{format('%.2f', basket.total)}"
