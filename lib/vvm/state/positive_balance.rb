# frozen_string_literal: true

module Vvm
  module State
    class PositiveBalance < Base
      def insert(coin)
        machine.balance += coin
        machine
      end

      def pick(product_name)
        product = machine.inventory.detect { _1.name == product_name }

        validate(product)

        machine.balance = (machine.balance - product.price).round(2)
        product.qty -= 1

        maybe_change_state

        product
      end

      private

      def validate(product)
        raise ProductNotFound unless product
        raise OutOfStock if product.qty.zero?
        raise InsufficientBalance if machine.balance < product.price
      end

      def maybe_change_state
        machine.state = Vvm::State::EmptyBalance.new(machine) if machine.balance.zero?
        machine.state = Vvm::State::SoldOut.new(machine) if machine.inventory.all? { _1.qty.zero? }
      end
    end
  end
end
