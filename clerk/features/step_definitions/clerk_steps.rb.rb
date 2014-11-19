When(/ingest "([^"]*)"/) do |image|
  bunny.channel.queue('boxes.drawings.ingest').publish File.read(image_path(image))
  sleep 2 # give time to process
end

Then(/should find "([^"]*)" in mongodb/) do |image|
  actual = drawings_collection.first['image'].to_s
  expect(actual).to eq File.read(image_path(image))
end