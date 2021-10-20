# frozen_string_literal: true

module Vvm
  class CLI
    module Command
      class << self
        def call(env, name, options)
          $stdout.clear_screen

          class_for(name).new(env).call(**options)
        end

        private

        def class_for(name)
          Base.by_command_name(name)
        end
      end
    end
  end
end
