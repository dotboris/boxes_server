require 'spec_helper'
require 'boxes/split_image'

describe Boxes::SplitImage do
  include FakeFS::SpecHelpers

  describe '#create!' do
    it 'should create the root path' do
      root = Pathname.new '/who/knows'

      Boxes::SplitImage.create! root

      expect(root.exist?).to be_truthy
      expect(root.directory?).to be_truthy
    end

    it 'should create a random dir in the root path' do
      root = Pathname.new '/maybe/he/can/tell/you'

      Boxes::SplitImage.create! root

      expect(root.children.size).to eq 1
    end

    it 'should return a new split image instance' do
      split_image = Boxes::SplitImage.create! Pathname.new '/he/knows/a/lot/of/things'

      expect(split_image).to be_a Boxes::SplitImage
    end

    it 'should create a unique dir' do
      allow(SecureRandom).to receive(:uuid).and_return('a', 'b')
      root = Pathname.new '/he/knows/everybodys/secrets'
      (root + 'a').mkpath

      Boxes::SplitImage.create! root

      expect(root.children).to include(root + 'a', root + 'b')
    end
  end

  describe '#save!' do
    it 'should save the original image as original.png' do
      root = Pathname.new '/beware'
      root.mkpath
      split_image = Boxes::SplitImage.new root

      split_image.original = 'the original'
      split_image.save!

      expect((root+'original.png').exist?).to be_truthy
      expect((root+'original.png').file?).to be_truthy
      expect((root+'original.png').open &:read).to eq 'the original'
    end

    it 'should save the row_count as row_count' do
      root = Pathname.new '/he/is'
      root.mkpath
      split_image = Boxes::SplitImage.new root

      split_image.row_count = 5
      split_image.save!

      expect((root+'row_count').exist?).to be_truthy
      expect((root+'row_count').file?).to be_truthy
      expect((root+'row_count').open &:read).to eq '5'
    end

    it 'should save the slices with numerical names' do
      root = Pathname.new '/watching/you'
      root.mkpath
      split_image = Boxes::SplitImage.new root

      split_image.slices = %w(a b c)
      split_image.save!

      expect((root+'0.png').exist?).to be_truthy
      expect((root+'0.png').open &:read).to eq 'a'
      expect((root+'1.png').exist?).to be_truthy
      expect((root+'1.png').open &:read).to eq 'b'
      expect((root+'2.png').exist?).to be_truthy
      expect((root+'2.png').open &:read).to eq 'c'
    end
  end

  describe '#activate!' do
    it 'should drop a file named active' do
      root = Pathname.new '/he/knows'
      root.mkpath
      split_image = Boxes::SplitImage.new root

      split_image.activate!

      expect((root+'active').exist?).to be_truthy
    end
  end

  describe '#inspect' do
    it 'should include dir, row_count and number of slices' do
      split_image = Boxes::SplitImage.new Pathname.new('/a/secret/place')
      split_image.row_count = 3
      split_image.slices = Array.new(10)

      expect(split_image.inspect).to eq '<Boxes::SplitImage: dir=/a/secret/place row_count=3 slices.size=10>'
    end
  end
end