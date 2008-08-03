module Rider
  module Debug
    def debug(str)
      puts "\e[33mDEBUG: #{str}\e[0m" if RIDER_DEBUG
    end
    module_function :debug

    def highlight(str)
      puts "\e[36m**** #{str}\e[0m"
    end
    module_function :highlight

    def hie(obj)
      highlight obj.inspect
      exit!
    end
    module_function :hie
  end
end