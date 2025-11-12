# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

class Basket
  attr_reader :catalogue, :delivery_rules, :offers, :items

  def initialize(catalogue:, delivery_rules:, offers: [])
    @catalogue = catalogue
    @delivery_rules = delivery_rules
    @offers = offers
    @items = []
  end

  def add(product_code)
    product = catalogue.find { |product| product.code == product_code }
    raise "Unknown product code: #{product_code}" unless product

    items << product
  end

  def total
    subtotal_after_discount = subtotal - total_discount

    delivery_charge = fetch_delivery_charge(subtotal_after_discount)
    (subtotal_after_discount + delivery_charge).round(2)
  end

  private

  def subtotal
    items.sum(&:price)
  end

  def total_discount
    offers.sum { |offer| offer.discount(items) }
  end

  def fetch_delivery_charge(amount)
    rule = delivery_rules.find { |rule| rule.applies_to?(amount) }
    rule ? rule.charge : BigDecimal('0')
  end
end
