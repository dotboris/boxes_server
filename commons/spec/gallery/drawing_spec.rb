require 'gallery/drawing'
require 'mongo_mapper'
require 'mongo'

describe Gallery::Drawing, :real_mongo do
  before do
    # noinspection RubyStringKeysInHashInspection
    MongoMapper.setup({'test' => {'uri' => mongodb_url}}, 'test')
  end

  it 'should save to db' do
    drawing = Gallery::Drawing.new image: 'some binary image blob'
    drawing.save!

    expect(drawings_collection.count).to eq 1
    expect(drawings_collection.find_one['_id']).to eq drawing.id

    expect(drawings_collection.find_one['image']).not_to be_nil
    expect(drawings_collection.find_one['image']).to eq drawing.image
  end

  it 'should find single from db' do
    drawing = {image: BSON::Binary.new('some other binary blob')}
    id = drawings_collection.insert(drawing)

    retrieved = Gallery::Drawing.find id

    expect(retrieved).not_to be_nil
    expect(retrieved.id).to eq id
    expect(retrieved.image).to eq 'some other binary blob'
  end

  # noinspection RubyResolve
  it 'should fetch list from db' do
    drawings = [
        {image: BSON::Binary.new('a')},
        {image: BSON::Binary.new('b')},
        {image: BSON::Binary.new('c')}
    ]
    drawings_collection.insert drawings

    retrieved = Gallery::Drawing.all

    expect(retrieved.size).to eq 3
    expect(retrieved.map(&:image)).to include('a', 'b', 'c')
  end

  it 'should serialize to json' do
    id = BSON::ObjectId.new
    drawing = Gallery::Drawing.new id: id, image: 'a big old blob of binary data'

    json = JSON.parse drawing.to_json

    expect(json['id']).to eq id.to_s
    expect(json['image']).not_to be_nil
  end
end