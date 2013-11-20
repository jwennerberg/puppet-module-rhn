require 'spec_helper'
describe 'rhn' do

  context 'with default options' do
    it {
      should include_class('rhn')
    }
  end
end
