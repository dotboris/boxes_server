# encoding: utf-8

When(/ingest "([^"]*)"/) do |image|
  bunny.channel.queue('boxes.collages.ingest').publish File.read(image_path(image))
  sleep 2 # give time to process
end

Then(/should find "([^"]*)" in mongodb/) do |image|
  actual = drawings_collection.find_one['image'].to_s
  expect(actual).to eq File.read(image_path(image)).force_encoding('BINARY')
end