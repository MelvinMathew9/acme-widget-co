# frozen_string_literal: true

require_relative '../../spec_helper'
require 'rules/delivery_rules/delivery_rule'
require 'rules/delivery_rules/fixed_delivery_rule'

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

  describe 'defaults and bounds' do
    it 'defaults min_spend to 0 when not provided' do
      rule = DeliveryRule.new(max_spend: '10', charge: '1.00')
      expect(rule.min_spend).to eq(BigDecimal('0'))
    end

    it 'treats nil max_spend as unbounded' do
      rule = DeliveryRule.new(min_spend: '50', charge: '4.99')
      expect(rule.max_spend).to be_nil
    end
  end
end
