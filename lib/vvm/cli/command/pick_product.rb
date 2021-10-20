# frozen_string_literal: true

module Vvm
  class CLI
    module Command
      class ShowProducts < Base
        self.command_name = :pick_product

        def call
          prompt.say("Balance: $#{machine.balance}")

          result = prompt.select('Please select', inventory_choices.push({ name: 'Back', value: :back }))

          if result == :back
            env.call(:show_main_menu)
          else
            env.call(:confirm_product_pick, { picked_product: machine.pick(result) })
          end
        end

        private

        def inventory_choices
          machine.inventory.map do |product|
            {
              name: "#{product.name} - $#{product.price} x #{product.qty}",
              value: product.name,
              **maybe_overpriced(product),
              **maybe_out_of_stock(product)
            }
          end
        end

        def maybe_overpriced(product)
          machine.balance < product.price ? { disabled: '(insufficient funds)' } : {}
        end

        def maybe_out_of_stock(product)
          product.qty.zero? ? { disabled: '(out of stock)' } : {}
        end
      end
    end
  end
end
