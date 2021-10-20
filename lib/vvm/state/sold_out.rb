# frozen_string_literal: true

module Vvm
  module State
    class SoldOut < Base
      def insert(_coin)
        raise MachineIsEmpty
      end

      def pick(_product_name)
        raise MachineIsEmpty
      end
    end
  end
end
