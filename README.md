# acme-widget-co

## Overview

- `lib/models/product.rb` — Product model (code, name, price). Prices are stored as BigDecimal.
- `lib/basket.rb` — Basket implementation: add items, compute subtotal, apply offers, pick delivery rule and calculate total.
- `lib/rules/delivery_rules` — Delivery rule classes (e.g. `FixedDeliveryRule`).
- `lib/rules/offers` — Offer classes (e.g. `BuyOneGetOneHalfPrice`).
- `lib/main.rb` — Example script that builds a catalogue, rules and prints a sample total.

## Running tests

This project uses RSpec.

```bash
gem install bundler
bundle install
bundle exec rspec
```

## Running the example

Run the sample script that demos adding products and printing a formatted total:

```bash
ruby lib/main.rb
```

## Quick usage

Here's an example showing how the method is intended to be used:

```ruby
# Build a small catalogue
catalogue = [
  Product.new(code: 'A', name: 'Small Widget', price: '10.00'),
  Product.new(code: 'B', name: 'Large Widget', price: '20.00')
]

# Create rules/offers
delivery_rules = [FixedDeliveryRule.new(max_spend: 50, charge: '4.95')]
offers = []

basket = Basket.new(catalogue: catalogue, delivery_rules: delivery_rules, offers: offers)
basket.add('A')
basket.add('B')

# Returns a BigDecimal
total = basket.total
puts format('%.2f', total)
```

## Assumptions

- Prices and monetary values use `BigDecimal` for precision. `Product` accepts string or numeric prices and converts them to `BigDecimal`.
- Delivery rules:
  - `min_spend` defaults to `0` when not provided.
  - `max_spend` defaults to `nil`, which is treated as unbounded (no upper limit).
- Rounding and totals:
  - The `Basket#total` method returns a numeric `BigDecimal` and the sample script formats the number for display.
  - Final total rounding uses BigDecimal half-down tie-breaking (i.e. `.round(2, BigDecimal::ROUND_HALF_DOWN)`) so 54.375 -> 54.37 and 54.376 -> 54.38.
- Notes on formatting and display:
  - `Basket#total` returns a `BigDecimal` so callers can choose how to format/localize it. The example script `lib/main.rb` formats using `format('%.2f', total)`.
  - This keeps presentation separate from business logic and avoids coupling rounding/formatting decisions to calculation.

## Methods

- `Basket#add(product_code)`

  - Adds a product to the basket by matching `product_code` against the catalogue. Raises an error for unknown codes.

- `Basket#total`
  - Returns the final total as a `BigDecimal` (subtotal - offers + delivery). The formatting is intentionally left to the caller.

  
## Extending rules and offers

- Delivery rules and offers are intentionally extensible.
- Add a new rule by extending `DeliveryRule` and implementing `applies_to?(subtotal)` and `charge`.
- Add a new offer by extending `Offer` and implementing `discount(items)`.
