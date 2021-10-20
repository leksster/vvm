# frozen_string_literal: true

module Vvm
  class CLI
    module Command
      class ShowCoins < Base
        self.command_name = :insert_coin

        def call
          result = prompt.slider(
            'Coin',
            [0.25, 0.50, 1.00, 2.00, 5.00, 10.00, 50.00, 100.00],
            help: '(Move arrows left and right to set value)',
            format: ':slider $%.2f'
          )

          machine.insert(result)

          # byebug

          env.call(:show_main_menu)
        end
      end
    end
  end
end
