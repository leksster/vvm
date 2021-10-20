# frozen_string_literal: true

module Vvm
  class CLI
    module Command
      class Base
        extend Forwardable

        attr_reader :env

        def_delegators :env, :machine, :prompt

        @subclasses = []

        class << self
          attr_accessor :command_name

          def inherited(subclass)
            super
            @subclasses << subclass
          end

          def by_command_name(name)
            @subclasses.detect { |s| s.command_name == name }
          end
        end

        def initialize(env)
          @env = env
        end
      end
    end
  end
end
