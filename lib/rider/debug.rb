module Rider
  module Debug
    def debug(str)
      puts "\e[33mDEBUG: #{str}\e[0m" if RIDER_DEBUG
    end

    def highlight(str)
      puts "\e[36m**** #{str}\e[0m"
    end

    def hie(obj)
      highlight obj.inspect
      exit!
    end
  end
end