# frozen_string_literal: true

require_relative '../../spec_helper'
require 'rules/delivery_rules/delivery_rule'

RSpec.describe DeliveryRule do
  let(:rule) { DeliveryRule.new }
  describe '#applies_to?' do
    it 'defaults to false' do
      expect(rule.applies_to?(0)).to be false
      expect(rule.applies_to?(100)).to be false
    end
  end

  describe '#charge' do
    it 'returns zero as BigDecimal' do
      expect(rule.charge).to eq(BigDecimal('0'))
    end
  end
end
