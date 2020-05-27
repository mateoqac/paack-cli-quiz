require './lib/api_service'

class Eltiempo < Thor
  include ApiService

  desc "today CITY", ""

  def today(city)
    ApiService.today(city)
  end

  desc "av_max CITY", ""

  def av_max(city)
    ApiService.av_max(city)
  end

  desc "av_min CITY", ""

  def av_min(city)
    ApiService.av_min(city)
  end

  def self.exit_on_failure?
    true
  end
end
