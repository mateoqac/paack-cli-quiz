module ArgumentGuard
  def self.missing_argument?(param)
    STDOUT.puts "Please write a city name (between quotes) after the command name" if param.nil?
    return  param.nil?
  end
end
