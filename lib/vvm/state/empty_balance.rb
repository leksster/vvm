# frozen_string_literal: true

module Vvm
  module State
    class EmptyBalance < Base
      def insert(coin)
        machine.balance += coin
        machine.state = Vvm::State::PositiveBalance.new(machine) unless coin <= 0
        machine
      end

      def pick(_product_name)
        raise InsufficientBalance
      end
    end
  end
end
