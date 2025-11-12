# frozen_string_literal: true

require_relative '../../spec_helper'
require 'rules/delivery_rules/fixed_delivery_rule'

RSpec.describe FixedDeliveryRule do
  let(:rule) { FixedDeliveryRule.new(min_spend: '10', max_spend: '50', charge: '4.95') }

  describe '#applies_to?' do
    it 'is false below min_spend' do
      expect(rule.applies_to?(BigDecimal('9.99'))).to be false
    end

    it 'is true at min_spend' do
      expect(rule.applies_to?(BigDecimal('10'))).to be true
    end

    it 'is true just below max_spend' do
      expect(rule.applies_to?(BigDecimal('49.99'))).to be true
    end

    it 'is false at or above max_spend' do
      expect(rule.applies_to?(BigDecimal('50'))).to be false
      expect(rule.applies_to?(BigDecimal('50.1'))).to be false
      expect(rule.applies_to?(BigDecimal('100'))).to be false
    end
  end

  describe '#charge' do
    it 'stores charge as BigDecimal' do
      expect(rule.charge).to eq(BigDecimal('4.95'))
    end
  end
end
