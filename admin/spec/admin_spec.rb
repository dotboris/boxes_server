require 'spec_helper'
require 'boxes/admin_version'

describe Boxes do
  it 'should have an admin version number' do
    expect(Boxes::ADMIN_VERSION).not_to be_nil
  end
end