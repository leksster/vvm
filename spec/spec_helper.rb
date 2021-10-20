# frozen_string_literal: true

require 'vvm'

module SpecMixin
  def ask(input)
    answer :ask, with: input
  end

  def yes?(input)
    answer :yes?, with: input
  end

  def select(input)
    answer :select, with: input
  end

  def answer(method, with:)
    expect(subject.prompt).to receive(method.to_sym).and_return(with)
  end
end

RSpec.configure do |config|
  config.include SpecMixin, tty: true
  config.include SpecMixin, type: :tty
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
