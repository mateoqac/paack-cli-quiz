require "json"
require 'rexml/document'
include REXML

module ResponseParse

  def self.today_response(response)
    parsed = JSON.parse(response.body)['day']['1']
    current_time = parsed['local_time']
    intervals =  parsed['hour']
    result = 0
    intervals.each do |inter|
      inter['interval'] > current_time ? break : result = inter['temp']
    end
    puts result
  end

  def self.average_response(response, key)
    xmldoc = Document.new(response.body)
    data = XPath.first(xmldoc, "//report//location//var//name[contains(text(),'#{key}')]/following-sibling::data")
    result = data.to_a.map {|ea| ea.attributes['value'].to_i}.inject(0) {|ac, e| ac + e}/data.size
    puts result
  end
end
