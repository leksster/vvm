# frozen_string_literal: true

module Vvm
  module State
    class SoldOut < Base
      def insert(_coin)
        raise MachineEmpty
      end
    end
  end
end
