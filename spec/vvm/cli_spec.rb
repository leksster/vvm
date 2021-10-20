# frozen_string_literal: true

require 'tty-prompt'
require 'tty/prompt/test'
require 'byebug'

class StringIO
  def ioctl(*)
    80
  end
end

RSpec.describe Vvm::CLI::Environment do
  before { allow($stdout).to receive(:clear_screen) }

  let(:prompt) { TTY::Prompt::Test.new }

  before do
    allow(TTY::Prompt).to receive(:new).and_return(prompt)

    prompt.on(:keypress) do |e|
      prompt.trigger(:keydown) if e.value == 'd'
      prompt.trigger(:keyright) if e.value == 'l'
    end
  end

  describe 'show_main_menu' do
    it 'shows main menu ' do
      prompt.input << 'd' << ' '
      prompt.input.rewind

      expect(subject).to receive(:call).with(:show_main_menu).and_call_original
      expect(subject).to receive(:call).with(:pick_product)

      subject.call(:show_main_menu)

      expect(prompt.output.string).to eq([
        "Balance: $0\n\e[?25lMain menu: \e[90m(Press ↑/↓ arrow to move and Enter to select)",
        "\e[0m\n\e[32m‣ Insert a coin\e[0m\n  Pick the product\n\e[31m✘\e[0m Dispense (empty balance)\n  ",
        "Exit\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1GMain menu: \n  ",
        "Insert a coin\n\e[32m‣ Pick the product\e[0m\n\e[31m✘\e[0m Dispense (empty balance)\n  ",
        "Exit\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1GMain menu: ",
        "\e[32mPick the product\e[0m\n\e[?25h"
      ].join)
    end
  end

  describe 'insert_coin' do
    it 'selects proper coin' do
      prompt.input << "l\r"
      prompt.input.rewind

      expect(subject).to receive(:call).with(:insert_coin).and_call_original
      expect(subject).to receive(:call).with(:show_main_menu)

      expect { subject.call(:insert_coin) }
        .to change { subject.machine.balance }
        .from(0).to(10.0)

      expect(prompt.output.string).to eq([
        "\e[?25lCoin ────\e[32m●\e[0m─── $5.00\n\e[90m(Move arrows left and right to set value)",
        "\e[0m\e[2K\e[1G\e[1A\e[2K\e[1GCoin ─────\e[32m●\e[0m── $10.00\e[2K\e[1GCoin \e[32m10.0\e[0m\n\e[?25h"
      ].join)
    end
  end

  describe 'pick_product' do
    before do
      subject.machine.state = Vvm::State::PositiveBalance.new(subject.machine)
      allow(subject.machine).to receive(:balance).and_return(50.0)
    end

    it 'picks the product' do
      prompt.input << 'd' << ' '
      prompt.input.rewind

      expect(subject).to receive(:call).with(:pick_product).and_call_original
      expect(subject).to receive(:call).with(:confirm_product_pick, anything)

      expect(subject.machine).to receive(:pick).with('Sprite')

      subject.call(:pick_product)

      expect(prompt.output.string).to eq([
        "Balance: $50.0\n\e[?25lPlease select \e[90m(Press ↑/↓ arrow to move and Enter to select)",
        "\e[0m\n\e[32m‣ Coca Cola - $2.0 x 2\e[0m\n  Sprite - $2.5 x 2\n  Fanta - $2.7 x 3\n  ",
        "Orange Juice - $3.0 x 1\n\e[31m✘\e[0m Water - $3.25 x 0 (out of stock)\n  ",
        "Back\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1G",
        "Please select \n  Coca Cola - $2.0 x 2\n\e[32m‣ Sprite - $2.5 x 2\e[0m\n  Fanta - $2.7 x 3\n  ",
        "Orange Juice - $3.0 x 1\n\e[31m✘\e[0m Water - $3.25 x 0 (out of stock)\n  ",
        "Back\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e",
        "[1GPlease select \e[32mSprite - $2.5 x 2\e[0m\n\e[?25h"
      ].join)
    end
  end
end
