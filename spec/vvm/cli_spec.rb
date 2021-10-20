# frozen_string_literal: true

RSpec.describe Vvm::CLI::Environment do
  it 'works' do
    result = described_class.new.call(:show_main_menu)
    expect(result).not_to be_nil
  end
end
