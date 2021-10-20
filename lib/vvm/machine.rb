# frozen_string_literal: true

module Vvm
  class Machine
    extend Forwardable

    GEM_HOME = File.realpath(File.join(File.dirname(__FILE__), '..', '..'))

    attr_accessor :balance, :state, :inventory, :coins

    def_delegators :state, :insert, :pick, :dispense

    def initialize
      @inventory = build_inventory
      @coins = build_coins
      @balance = 0
      @state = Vvm::State::EmptyBalance.new(self)
    end

    private

    def config
      @config ||= YAML.load_file(File.join(GEM_HOME, 'config/default.yaml'))
    end

    def build_inventory
      config['inventory'].map { Vvm::Model::Product.new(*_1.values) }
    end

    def build_coins
      config['coins'].map { Vvm::Model::Coin.new(*_1.values) }
    end
  end
end
