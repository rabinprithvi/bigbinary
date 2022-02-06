# frozen_string_literal: true

class Item
  OFFER_PRICE = nil
  OFFER_UNITS = nil

  def calculate_cost(units)
    @units = units
    offer_available? ? offer_cost : standard_cost
  end

  private

  def offer_cost
    cost_of_offer_units + cost_of_remaining_units
  end

  def units_with_offer
    @units / self.class::OFFER_UNITS
  end

  def units_without_offer
    @units % self.class::OFFER_UNITS
  end

  def offer_available?
    !self.class::OFFER_PRICE.nil?
  end

  def standard_cost
    @units * self.class::UNIT_PRICE
  end

  def cost_of_offer_units
    units_with_offer * self.class::OFFER_PRICE if offer_available?
  end

  def cost_of_remaining_units
    units_without_offer * self.class::UNIT_PRICE
  end
end
