# frozen_string_literal: true

module Vvm
  class Error < StandardError; end

  class InsufficientBalance < Error; end

  class ProductNotFound < Error; end

  class OutOfStock < Error; end

  class MachineIsEmpty < Error; end

  class InvalidInput < Error; end
end
