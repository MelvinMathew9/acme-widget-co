# frozen_string_literal: true

require_relative '../../spec_helper'
require 'rules/offers/offer'

RSpec.describe Offer do
  describe '#discount' do
    it 'returns zero by default' do
      offer = Offer.new
      expect(offer.discount([])).to eq(BigDecimal('0'))
    end
  end
end
