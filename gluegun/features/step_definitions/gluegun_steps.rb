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