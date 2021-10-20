# frozen_string_literal: true

module Vvm
  class CLI
    def call
      Environment.new.call(:show_main_menu)
    end
  end
end
