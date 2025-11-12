# frozen_string_literal: true

require_relative '../spec_helper'
require 'models/product'
require 'bigdecimal'
require 'bigdecimal/util'

RSpec.describe Product do
  describe '#initialize' do
    let(:product_code) { 'R01' }
    let(:product_name) { 'Red Widget' }
    let(:price) { '32.95' }
    let(:attrs) { { code: product_code, name: product_name, price: price } }
    let(:product) { Product.new(**attrs) }

    it 'sets code, name and price' do
      expect(product.code).to eq(product_code)
      expect(product.name).to eq(product_name)
      expect(product.price).to be_a(BigDecimal)
      expect(product.price).to eq(BigDecimal(price))
    end

    context 'when price is numeric' do
      let(:product_code) { 'G01' }
      let(:product_name) { 'Green Widget' }
      let(:price) { 5 }

      it 'accepts numeric prices and converts them to BigDecimal' do
        expect(product.price).to eq(price.to_d)
      end
    end
  end
end
