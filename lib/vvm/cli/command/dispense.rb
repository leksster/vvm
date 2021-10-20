# frozen_string_literal: true

module Vvm
  class CLI
    module Command
      class Dispsense < Base
        self.command_name = :dispense

        def call
          prompt.say("Balance: $#{machine.balance}")

          coins = machine.dispense.filter { _1.qty.positive? }.map { "#{_1.qty} x $#{_1.value}" }

          formatted_coins = coins.empty? ? '0' : coins.join(', ')

          env.call(:confirm_dispense, { formatted_coins: formatted_coins })
        end
      end
    end
  end
end
