require 'spec_helper'
require 'clerk'

describe Clerk do
  it 'should have version' do
    expect(Clerk::VERSION).not_to be_nil
  end
end