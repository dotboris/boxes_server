Then(/should find "([^"]*)" in the collages queue/) do |path|
  _, _, actual = bunny.channel.queue('boxes.collages.ingest').pop
  expected = load_image(path)

  expect(actual).not_to be_nil

  expect(as_png(actual)).to eq as_png(expected)
end