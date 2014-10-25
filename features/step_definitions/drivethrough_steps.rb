When(/retrieve an image/) do
  drivethrough.get '/slice'
end

Then(/should get a timeout error/) do
  expect(drivethrough.last_response.status).to eq 408
end

Then(/should get a slice/) do
  response = drivethrough.last_response
  expect(response.status).to eq 200
  expect(response.headers['Content-Type']).to eq 'image/png'
  expect(response.headers['Cache-Control']).to eq 'no-cache'
end