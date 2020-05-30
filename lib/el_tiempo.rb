require './lib/api_service'
require 'thor'

class Eltiempo < Thor
  include ApiService

  desc "today CITY", ""

  def today(city)
    STDOUT.puts "Today\'s temperature in #{city} is:" unless city.nil?
    ApiService.today(city)
  end

  desc "av_max CITY", ""

  def av_max(city)
    STDOUT.puts "Average maximum temprature this week in #{city} is:" unless city.nil?
    ApiService.av_max(city)
  end

  desc "av_min CITY", ""

  def av_min(city)
    STDOUT.puts "Average minimum temprature this week in #{city} is:" unless city.nil?
    ApiService.av_min(city)
  end

  def self.exit_on_failure?
    true
  end
end
