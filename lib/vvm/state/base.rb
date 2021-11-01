# frozen_string_literal: true

module Vvm
  module State
    class Base
      extend Forwardable

      def_delegators :machine, :coins, :balance

      def initialize(machine)
        @machine = machine
      end

      def insert(coin)
        raise NotImplementedError
      end

      def pick(product_name)
        raise NotImplementedError
      end

      def dispense
        result = Vvm::Dispenser.new(balance, coins).call

        machine.balance -= result.sum { _1.qty * _1.value }

        result
      end

      private

      attr_reader :machine
    end
  end
end
