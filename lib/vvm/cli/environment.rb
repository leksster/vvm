# frozen_string_literal: true

require 'tty-prompt'

module Vvm
  class CLI
    class Environment
      attr_reader :machine, :prompt

      def initialize
        @machine = Vvm::Machine.new
        @prompt = TTY::Prompt.new
      end

      def call(name, options = {})
        Command.call(self, name, options)
      end
    end
  end
end
