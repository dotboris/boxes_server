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
