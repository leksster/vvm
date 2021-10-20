# frozen_string_literal: true

module Vvm
  class CLI
    module Command
      class Dispsense < Base
        self.command_name = :dispense

        def call
          prompt.say("Balance: $#{machine.balance}")

          formatted_coins = machine.dispense.map { "#{_1.qty} x $#{_1.value}" }.join(', ')

          env.call(:confirm_dispense, { formatted_coins: formatted_coins })
        end
      end
    end
  end
end
