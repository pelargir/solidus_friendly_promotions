# frozen_string_literal: true

module SolidusFriendlyPromotions
  class ShipmentDiscounter
    attr_reader :promotions

    def initialize(promotions:)
      @promotions = promotions
    end

    def call(shipment)
      eligible_promotions = promotions.select do |promotion|
        PromotionEligibility.new(promotable: shipment, possible_promotions: promotions).call
      end

      possible_adjustments = eligible_promotions.flat_map do |promotion|
        promotion.actions.select do |action|
          action.can_discount?(shipment)
        end.map do |action|
          action.discount(shipment)
        end
      end
    end
  end
end