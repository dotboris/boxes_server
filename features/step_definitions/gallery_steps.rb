Then(/should find "([^"]+)" in the gallery/) do |path|
  expected = load_image(path)

  gallery.get '/'

  expect(gallery.last_response.status).to eq 200
  ids = JSON.parse gallery.last_response.body
  expect(ids.size).to eq 1

  gallery.get "/#{ids.first}"

  expect(gallery.last_response.status).to be 200
  actual = gallery.last_response.body

  expect(as_png(actual)).to eq as_png(expected)
end