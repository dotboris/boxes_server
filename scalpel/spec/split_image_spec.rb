require 'spec_helper'
require 'boxes/scalpel/split_image'

describe Boxes::Scalpel::SplitImage do
  include FakeFS::SpecHelpers

  describe '#create!' do
    it 'should create the root path' do
      root = Pathname.new '/who/knows'

      Boxes::Scalpel::SplitImage.create! root

      expect(root.exist?).to be_truthy
      expect(root.directory?).to be_truthy
    end

    it 'should create a random dir in the root path' do
      root = Pathname.new '/maybe/he/can/tell/you'

      Boxes::Scalpel::SplitImage.create! root

      expect(root.children.size).to eq 1
    end

    it 'should return a new split image instance' do
      split_image = Boxes::Scalpel::SplitImage.create! Pathname.new '/he/knows/a/lot/of/things'

      expect(split_image).to be_a Boxes::Scalpel::SplitImage
    end

    it 'should create a unique dir' do
      allow(SecureRandom).to receive(:uuid).and_return('a', 'b')
      root = Pathname.new '/he/knows/everybodys/secrets'
      (root + 'a').mkpath

      Boxes::Scalpel::SplitImage.create! root

      expect(root.children).to include(root + 'a', root + 'b')
    end
  end
end