# frozen_string_literal: true

module Vvm
  class Dispenser
    def initialize(amount, coins)
      @amount = amount
      @coins = coins
      @min_coins = []
      @min_qty = 0
      @subset = coins
    end

    def call # rubocop:disable Metrics/AbcSize
      return give_away if not_enough_change?

      coins.each_with_object([]).with_index do |(_, memo), index|
        self.subset = define_subset(index)

        result = calculate(subset, amount)

        memo << result if result.sum { _1.value * _1.qty } == amount

        match_qty = calculate_min_qty(memo)

        calibrate(memo, match_qty) if min_coins.empty? || match_qty < min_qty
      end

      min_coins
    end

    private

    attr_reader :amount, :coins
    attr_accessor :min_coins, :min_qty, :subset

    def give_away
      coins.map do |coin|
        dup = coin.dup
        coin.qty = 0
        dup
      end
    end

    def not_enough_change?
      amount > coins.sum { _1.value * _1.qty }
    end

    def define_subset(index)
      coins.dup.tap do |list|
        list.delete_at(index) unless index.zero?
        list.each { |coin| coin.qty = initial_coins.detect { coin.value == _1.value }.qty }
      end
    end

    def calculate_min_qty(coins_matrix)
      coins_matrix.min_by { _1.sum(&:qty) }.sum(&:qty)
    end

    def calibrate(coins_matrix, match_qty)
      self.min_coins = coins_matrix.detect { _1.sum(&:qty) == match_qty }
      self.min_qty = match_qty
    end

    def calculate(coins, change, index = 0) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      coins.drop(index).each_with_object([]).with_index do |(coin, memo), idx|
        remainder = change % coin.value

        if coin.qty.positive? && coin.value <= change && remainder < change
          required_qty = [coin.qty, (change - remainder) / coin.value].min

          memo << Vvm::Model::Coin.new(coin.value, required_qty)

          amount = required_qty * coin.value
          change_left = change - amount
          coin.qty -= 1

          break memo if change_left.zero?

          sub_result = calculate(coins, change_left, idx + 1)

          break unless sub_result

          return memo + sub_result
        end
      end
    end

    def initial_coins
      @initial_coins ||= coins.map(&:dup)
    end
  end
end
