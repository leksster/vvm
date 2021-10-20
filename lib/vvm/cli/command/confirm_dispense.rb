# frozen_string_literal: true

module Vvm
  class CLI
    module Command
      class ConfirmDispsense < Base
        self.command_name = :confirm_dispense

        def call(formatted_coins:)
          prompt.ok "You've got: #{formatted_coins} coins"

          prompt.yes?('Would you like to return to main menu?') ? env.call(:show_main_menu) : exit
        end
      end
    end
  end
end
