# frozen_string_literal: true

module Vvm
  class CLI
    module Command
      class ShowMainMenu < Base
        self.command_name = :show_main_menu

        def call
          prompt.say("Balance: $#{machine.balance}")

          choices = [
            { name: 'Insert a coin', value: :insert_coin, **maybe_out_of_stock },
            { name: 'Pick the product', value: :pick_product },
            { name: 'Dispense', value: :dispense, **maybe_empty_balance, **maybe_no_change }
          ]

          result = prompt.select('Main menu:', choices)

          env.call(result)
        end

        private

        def maybe_empty_balance
          machine.balance.zero? ? { disabled: '(empty balance)' } : {}
        end

        def maybe_no_change
          machine.coins.all? { _1.qty.zero? } ? { disabled: '(no coins)' } : {}
        end

        def maybe_out_of_stock
          machine.inventory.all? { _1.qty.zero? } ? { disabled: '(machine is empty)' } : {}
        end
      end
    end
  end
end
