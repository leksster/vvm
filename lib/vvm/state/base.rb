# frozen_string_literal: true

module Vvm
  module State
    class Base
      def initialize(machine)
        @machine = machine
      end

      def insert(coin)
        raise NotImplementedError
      end

      def pick(product_name)
        raise NotImplementedError
      end

      def dispense # rubocop:disable Metrics/AbcSize
        machine.coins.each_with_object([]) do |coin, acc|
          next if coin.value > machine.balance

          unbalansed_qty = (machine.balance / coin.value).floor
          qty_to_return = unbalansed_qty > coin.qty ? coin.qty : unbalansed_qty

          coin_to_return = coin.dup
          coin_to_return.qty = qty_to_return

          acc.push(coin_to_return)
          coin.qty -= qty_to_return

          machine.balance = (machine.balance - (coin.value * qty_to_return)).round(2)
        end
      end

      private

      attr_reader :machine
    end
  end
end
