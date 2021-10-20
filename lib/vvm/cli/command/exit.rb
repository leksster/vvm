# frozen_string_literal: true

module Vvm
  class CLI
    module Command
      class Exit < Base
        self.command_name = :exit

        def call
          exit
        end
      end
    end
  end
end
