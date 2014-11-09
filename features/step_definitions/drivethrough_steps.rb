When(/retrieve an image/) do
  drivethrough.get '/slice'
end

Then(/should get a timeout error/) do
  expect(drivethrough.last_response.status).to eq 408
end

Then(/should get a slice/) do
  response = drivethrough.last_response
  expect(response.status).to eq 200
  expect(response.headers['Content-Type']).to eq 'application/json'
  expect(response.headers['Cache-Control']).to eq 'no-cache'

  body = JSON.parse response.body

  expect(body['id']).not_to be_nil
  expect(body['queue']).not_to be_nil
  expect(body['image']).not_to be_nil

  as_png(Base64.decode64 body['image'])
end

When(/draw (\d+) slices/) do |count|
  count.to_i.times do
    drivethrough.get '/slice'
    slice = JSON.parse drivethrough.last_response.body

    sleep 1

    drivethrough.put "/drawings/#{slice['queue']}/#{slice['id']}",
                     Base64.decode64(slice['image']), 'Content-Type' => 'image/png'
  end

  sleep count.to_i
end