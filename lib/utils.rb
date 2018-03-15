module Utils

  def set_payload
    raw_data = request.body.read
    @payload = raw_data.empty? ? {} : as_json(raw_data)
  end

  private

  def as_json(str)
    JSON.parse(str, symbolize_names: true)
  end

end