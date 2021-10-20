# frozen_string_literal: true

module Vvm
  class CLI
    module Command
      class ConfirmProductPick < Base
        self.command_name = :confirm_product_pick

        def call(picked_product:)
          prompt.ok "You've got: #{picked_product.name}"

          prompt.yes?('Would you like to return to main menu?') ? env.call(:show_main_menu) : exit
        end
      end
    end
  end
end
