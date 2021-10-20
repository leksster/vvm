# frozen_string_literal: true

RSpec.describe Vvm::Machine do
  let(:machine) { Vvm::Machine.new }

  describe '#new' do
    it 'can be initialized' do
      expect { machine }.not_to raise_error
      expect(machine.state.class).to eq(Vvm::State::EmptyBalance)
    end
  end

  describe '#inventory' do
    it 'has correct inventory' do
      expect(machine.inventory.length).to eq 5
      expect(machine.inventory.first).to be_a(Struct)
    end
  end

  describe '#coins' do
    it 'has correct coins' do
      expect(machine.coins.length).to eq 6
      expect(machine.coins.first).to be_a(Struct)
    end
  end

  describe '#insert' do
    context 'when balance is 0' do
      it do
        expect { machine.insert(10) }
          .to change { machine.balance }
          .from(0)
          .to(10)
          .and change { machine.state.class }
          .from(Vvm::State::EmptyBalance)
          .to(Vvm::State::PositiveBalance)
      end
    end

    context 'when argument is not valid' do
      it 'is error' do
        expect { machine.insert('fasf') }.to raise_error(TypeError)
      end
    end

    context 'when balance is 5' do
      before { machine.balance = 5 }

      it do
        expect { machine.insert(10) }
          .to change { machine.balance }
          .from(5)
          .to(15)
      end
    end
  end

  describe '#pick' do
    context 'when balance is 0' do
      it { expect { machine.pick('Coca Cola') }.to raise_error(Vvm::InsufficientBalance) }
    end

    context 'when wrong product name provided' do
      before { machine.insert(10) }

      it { expect { machine.pick('bla') }.to raise_error(Vvm::ProductNotFound) }
    end

    context 'when qty is 0' do
      before { machine.insert(10) }

      it { expect { machine.pick('bla') }.to raise_error(Vvm::ProductNotFound) }
    end

    context 'when balance is 2' do
      before { machine.insert(2) }

      let(:result) { machine.pick('Coca Cola') }

      it 'changes the state' do
        expect { result }
          .to change(machine, :balance)
          .from(2)
          .to(0)
          .and change { machine.state.class }
          .from(Vvm::State::PositiveBalance)
          .to(Vvm::State::EmptyBalance)
      end
    end

    context 'when all products are picked' do
      before { machine.inventory = [Vvm::Model::Product.new('water', 0.25, 1)] }

      it 'transitions to sold out' do
        expect { machine.insert(0.25).pick('water') }
          .to change { machine.state.class }
          .from(Vvm::State::EmptyBalance)
          .to(Vvm::State::SoldOut)
      end
    end
  end

  describe '#dispense' do
    context 'when balance is 0' do
      it 'returns empty array' do
        expect(machine.dispense).to eq []
      end
    end

    context 'when balance is 5' do
      before { machine.insert(5) }

      it 'returns 1 coin' do
        expect(machine.dispense).to include(an_object_having_attributes(value: 5, qty: 1))
      end
    end

    context 'when balance is 10' do
      before { machine.insert(10) }

      it 'returns 2 coins' do
        expect(machine.dispense).to include(an_object_having_attributes(value: 5, qty: 2))
      end
    end

    context 'when balance is 15' do
      before { machine.insert(15) }

      it 'returns 3 coins' do
        expect(machine.dispense).to include(an_object_having_attributes(value: 5, qty: 3))
      end
    end

    context 'when balance is 14' do
      before { machine.insert(14) }

      it 'returns 4 coins' do
        expect(machine.dispense)
          .to contain_exactly(
            an_object_having_attributes(value: 5, qty: 2),
            an_object_having_attributes(value: 3, qty: 1),
            an_object_having_attributes(value: 1, qty: 1)
          )
      end
    end

    context 'when balance is 13.75' do
      before { machine.insert(13.75) }

      it 'returns 4 coins' do
        expect(machine.dispense)
          .to contain_exactly(
            an_object_having_attributes(value: 5, qty: 2),
            an_object_having_attributes(value: 3, qty: 1),
            an_object_having_attributes(value: 0.5, qty: 1),
            an_object_having_attributes(value: 0.25, qty: 1)
          )
      end
    end

    context 'when balance is 1000' do
      before { machine.insert(1000) }

      it 'returns all available coins' do
        expect(machine.dispense)
          .to contain_exactly(
            an_object_having_attributes(value: 5, qty: 5),
            an_object_having_attributes(value: 3, qty: 5),
            an_object_having_attributes(value: 2, qty: 5),
            an_object_having_attributes(value: 1, qty: 5),
            an_object_having_attributes(value: 0.5, qty: 5),
            an_object_having_attributes(value: 0.25, qty: 5)
          )
      end
    end
  end
end
