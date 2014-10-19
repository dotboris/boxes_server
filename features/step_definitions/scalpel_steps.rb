def a_split_image
  Pathname.new(media_root).children.first
end

Given(/have no split images/) do
  FileUtils.rm_rf Dir.glob(File.join(media_root, '*'))
end

Then(/should see (\d+) active split image/) do |count|
  images = Pathname.new(media_root).children.select { |p| (p + 'active').exist? }
  expect(images.size).to eq count.to_i
end

And(/should see a split image with (\d+) slices/) do |count|
  slices = a_split_image.children.select { |p| /^\d+\.png$/ =~ p.basename.to_s }
  expect(slices.size).to eq count.to_i
end

And(/should see a split image with a row_count of (\d+)/) do |row_count|
  expect((a_split_image+'row_count').read).to eq row_count
end