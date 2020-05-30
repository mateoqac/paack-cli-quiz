module ArgumentGuard
  def self.check_argument_present
    if ARGV[1].nil?
      STDOUT.puts "Please write a city name (between quotes) after the command name"
      return true
    end
  end
end
