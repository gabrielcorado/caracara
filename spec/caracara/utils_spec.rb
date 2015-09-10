# Include the helper
require 'spec_helper'

# Tests
describe 'Utils' do
  context 'merge method' do
    # Define the first array
      let(:first) {
      {
        a: 1,
        b: {
          c: 2,
          d: 3
        },
        e: {
          f: 4,
          g: 5
        }
      }
    }

    # Define the second array
    let(:second) {
      {
        b: {
          c: 15,
          abc: '123'
        },
        e: {
          g: 35
        }
      }
    }

    it 'should merge to arrays perfectly' do
      # Merge first -> second
      first_merge_result = Caracara::Utils.merge first, second

      # Merge second -> first
      second_merge_result = Caracara::Utils.merge second, first

      # Assertions
      expect(first_merge_result).to eq({a: 1, b: {abc: '123', c: 15, d: 3}, e: {f: 4, g: 35}})
      expect(second_merge_result).to eq({b: {c: 2, abc: '123', d: 3}, e: {g: 5, f: 4}, a: 1})
    end
  end
end
