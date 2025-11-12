# frozen_string_literal: true

require_relative '../../spec_helper'
require 'rules/offers/buy_one_get_one_half_price'
require 'models/product'

RSpec.describe BuyOneGetOneHalfPrice do
  let(:red_product_code) { 'TR01' }
  let(:offer) { BuyOneGetOneHalfPrice.new(red_product_code) }
  let(:red_widget) { Product.new(code: red_product_code, name: 'Red Widget', price: '10') }
  let(:green_widget) { Product.new(code: 'TG01', name: 'Green Widget', price: '20.5') }

  it 'returns zero when no items match' do
    basket_items = [green_widget]
    expect(offer.discount(basket_items)).to eq(BigDecimal('0'))
  end

  it 'calculates half price discounts for pairs of matching items' do
    items = [red_widget, red_widget, green_widget]
    expected_discount = BigDecimal(red_widget.price / 2)
    expect(offer.discount(items)).to eq(expected_discount)
  end

  it 'applies discount for multiple pairs' do
    items = Array.new(5) { red_widget } + Array.new(2) { green_widget }
    # 5 red_widgets -> 2 discounts
    expected_discount = BigDecimal((red_widget.price / 2) * 2)
    expect(offer.discount(items)).to eq(expected_discount)
  end
end
