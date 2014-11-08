require 'base64'

class Forklift
  Slice = Struct.new :queue, :id, :image do
    def to_json
      {
          queue: queue, id: id,
          image: base64_image
      }.to_json
    end

    private

    def base64_image
      Base64.encode64(image).strip if image
    end
  end
end