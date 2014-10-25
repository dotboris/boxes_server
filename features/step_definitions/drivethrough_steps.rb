When(/retrieve an image/) do
  drivethrough.get '/slice'
end

Then(/should get a timeout error/) do
  expect(drivethrough.last_response.status).to eq 408
end