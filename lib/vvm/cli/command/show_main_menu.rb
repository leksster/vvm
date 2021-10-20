# frozen_string_literal: true

module Vvm
  class CLI
    module Command
      class ShowMainMenu < Base
        self.command_name = :show_main_menu

        def call
          prompt.say("Balance: $#{machine.balance}")

          result = prompt.select('Main menu:') do |menu|
            menu.choice 'Insert a coin', :insert_coin
            menu.choice 'Pick the product', :pick_product
            menu.choice 'Dispense', :dispense, machine.balance.zero? && { disabled: '(empty balance)' }
          end

          env.call(result)
        end
      end
    end
  end
end
