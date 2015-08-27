require 'spec_helper'
require 'app/models/concerns/status_without_values'
require 'app/models/concerns/status'
require 'app/models/red_ball'
require 'mongoid'

describe EnumizeMongoid do
  it 'has a version number' do
    expect(EnumizeMongoid::VERSION).not_to be nil
  end

  before(:each) do
    # instead of database cleaner
    RedBall.delete_all
  end

  after(:each) do
    # instead of database cleaner
    RedBall.delete_all
  end

  describe 'enumize' do
    before(:each) do
      StatusWithoutValues.constants.each do |constant|
        StatusWithoutValues.send(:remove_const, constant)
      end

      StatusWithoutValues.enumize(values, create_constants: create_constants)
    end

    let(:value_map) { StatusWithoutValues.class_variable_get('@@value_map') }

    describe 'values' do
      let(:create_constants) { true }

      context 'when values are in an Array' do
        let(:values) { [:bouncing, :still] }

        it 'sets up the @@value_map based on the indexes' do
          expect(value_map[:bouncing]).to be == 0
          expect(value_map[:still]).to be == 1
        end
      end

      context 'when values are in a Hash' do
        let(:bouncing_val) { 2 }
        let(:still_val) { 5 }
        let(:values) { { bouncing: bouncing_val, still: still_val } }

        it 'sets up the @@value_map based on the values' do
          expect(value_map[:bouncing]).to be == bouncing_val
          expect(value_map[:still]).to be == still_val
        end
      end
    end

    describe 'create_constans' do
      let(:values) { [:bouncing, :still] }

      context 'when it is true' do
        let(:create_constants) { true }

        it 'creates the VALUES constant' do
          expect(StatusWithoutValues::VALUES).to be == value_map
        end

        it 'creates the BOUNCING constant' do
          expect(StatusWithoutValues::BOUNCING).to be == 0
        end

        it 'creates the STILL constant' do
          expect(StatusWithoutValues::STILL).to be == 1
        end
      end

      context 'when it is false' do
        let(:create_constants) { false }

        it 'does not create any constant' do
          expect(StatusWithoutValues.constants).to match_array([])
        end
      end
    end
  end

  describe 'object creation' do
    let(:status_sym) { :bouncing }
    let(:status_obj) { Status.new(status_sym) }
    let(:status_num) { Status::VALUES[status_sym] }

    context 'when field is specified as symbol' do
      let(:obj) { RedBall.new(status: status_sym) }

      it 'saves the object properly' do
        expect { obj.save! }.to_not raise_error
      end

      it 'returns the underlying value as number' do
        expect(obj[:status]).to be == Status::BOUNCING
      end
    end

    context 'when field is specified as number' do
      let(:obj) { RedBall.new(status: status_num) }

      it 'saves the object properly' do
        expect { obj.save! }.to_not raise_error
      end

      it 'returns the underlying value as number' do
        expect(obj[:status]).to be == Status::BOUNCING
      end
    end

    context 'when field is specified as a Status object' do
      let(:obj) { RedBall.new(status: status_obj) }

      it 'saves the object properly' do
        expect { obj.save! }.to_not raise_error
      end

      it 'returns the underlying value as number' do
        expect(obj[:status]).to be == Status::BOUNCING
      end
    end
  end

  describe 'accessors' do
    let(:status_sym) { :bouncing }
    let(:status_num) { Status::VALUES[status_sym] }

    let(:obj) { RedBall.create(status: status_sym).reload }

    subject { obj.status }

    context 'when compared to the corresponding numeric value' do
      it { is_expected.to be == Status::BOUNCING }
    end

    context 'when compared to the symbol representation ' do
      it { is_expected.to be == status_sym }
    end

    context 'when compared to a corresponding Status object' do
      it { is_expected.to be == Status.new(status_sym) }
    end

    it 'returns a Status object with the accessor' do
      expect(obj.status.class).to be Status
    end
  end

  describe 'querying' do
    before do
      RedBall.create(status: :bouncing)
      RedBall.create(status: :still)
    end

    context 'when using symbol values in selectors' do
      it 'finds the needed documents' do
        expect(RedBall.where(status: :bouncing).count).to be == 1
      end
    end

    context 'when using numerical values in selectors' do
      it 'finds the needed documents' do
        expect(RedBall.where(status: Status::STILL).count).to be == 1
      end
    end

    context 'when using Status objects in selectors' do
      it 'finds the needed documents' do
        expect(RedBall.where(:status.in => [Status.new(:bouncing), Status.new(:still)]).count).to be == 2
      end
    end
  end
end