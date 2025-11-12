# frozen_string_literal: true

require_relative 'spec_helper'
require 'models/product'
require 'basket'
require 'rules/delivery_rules/fixed_delivery_rule'
require 'rules/offers/buy_one_get_one_half_price'

RSpec.describe Basket do
  let(:red_product) { Product.new(code: 'R01', name: 'Red', price: '10') }
  let(:green_product) { Product.new(code: 'G01', name: 'Green', price: '20') }
  let(:catalogue) { [red_product, green_product] }
  let(:delivery_rules) { [FixedDeliveryRule.new(min_spend: '0', max_spend: '1000', charge: '0')] }
  subject(:basket) { described_class.new(catalogue: catalogue, delivery_rules: delivery_rules, offers: []) }

  describe '#add' do
    it 'adds a product by code' do
      basket.add('R01')
      expect(basket.items.first).to eq(red_product)
    end

    it 'raises for unknown product code' do
      expect { basket.add('B01') }.to raise_error(RuntimeError, /Unknown product code/)
    end
  end

  context 'with multiple delivery rules and offers' do
    let(:small_fee) { FixedDeliveryRule.new(min_spend: '0', max_spend: '50', charge: '4.99') }
    let(:free_delivery) { FixedDeliveryRule.new(min_spend: '50', charge: '0') }

    let(:offer) { BuyOneGetOneHalfPrice.new('R01') }

    subject(:basket) do
      described_class.new(
        catalogue: catalogue,
        delivery_rules: [small_fee, free_delivery],
        offers: [offer]
      )
    end

    it 'applies discount and correct delivery rule' do
      add_products(basket, 'R01', 'R01', 'R01', 'G01', 'G01')

      expect(basket.total).to eq(expected_total_for(basket, free_delivery))
    end

    it 'applies small fee when post discount subtotal is below threshold' do
      small_basket = described_class.new(
        catalogue: catalogue,
        delivery_rules: [small_fee, free_delivery],
        offers: [offer]
      )
      add_products(small_basket, 'R01', 'R01', 'G01')

      expect(small_basket.total).to eq(expected_total_for(small_basket, small_fee))
    end
  end

  def add_products(basket, *codes)
    codes.each { |code| basket.add(code) }
  end

  def expected_total_for(basket, delivery_rule)
    items = basket.items
    discount = basket.offers.sum { |offer| offer.discount(items) }
    subtotal_after_discount = items.sum(&:price) - discount

    delivery_charge = delivery_rule ? delivery_rule.charge : BigDecimal('0')
    (subtotal_after_discount + delivery_charge).round(2)
  end
end
