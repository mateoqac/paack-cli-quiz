class ResponseParseError < StandardError
  def message
    "The response cannot be parsed"
  end
end
