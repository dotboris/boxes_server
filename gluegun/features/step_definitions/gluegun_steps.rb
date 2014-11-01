Given(/request a (\d+)x(\d+) collage cut in (\d+)x(\d+)?/) do |width, height, rows, cols|
  request = {
      width: width.to_i,
      height: height.to_i,
      row_count: rows.to_i,
      col_count: cols.to_i,
      queue: queue_id
  }

  bunny.channel.queue('boxes.collages').publish request.to_json
end

When(/submit (\d+)x(\d+) drawings? "(\d+(?:,\s*\d+)*)"/) do |width, height, raw_ids|
  queue = bunny.channel.queue("boxes.drawings.#{queue_id}")

  ids = raw_ids.scan(/\d+/).map &:to_i
  ids.each do |id|
    image = Magick::Image.new width.to_i, height.to_i do
      self.format = 'PNG'
      self.depth = 8
    end

    drawing = {
        id: id,
        image: Base64.encode64(image.to_blob).strip
    }

    queue.publish drawing.to_json
  end
end

Then(/should find a (\d+)x(\d+) glued image/) do |width, height|
  _, _, payload = poll_queue('boxes.drawings.ingest', 2)

  image = Magick::Image.from_blob(payload).first

  expect(image.columns).to eq width
  expect(image.rows).to eq height
end