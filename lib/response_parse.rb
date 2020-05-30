require "json"
require 'rexml/document'

include REXML

module ResponseParse

  def self.today_response(response)
    raise ResponseParseError.new  unless response.code == 200

    current_time = JSON.parse(response.body)['day']['1']['local_time']
    intervals =  JSON.parse(response.body)['day']['1']['hour']
    result = 0
    intervals.each do |inter|
      inter['interval'] > current_time ? break : result = inter['temp']
    end
    result
  end

  def self.average_response(response, key)
    raise ResponseParseError.new  unless response.code == 200

    xmldoc = Document.new(response.body)

    data = XPath.first(xmldoc, "//report//location//var//name[contains(text(),'#{key}')]/following-sibling::data")
    result = data.to_a.map {|ea| ea.attributes['value'].to_i}.inject(0) {|ac, e| ac + e}/data.size
    result
  end
end
