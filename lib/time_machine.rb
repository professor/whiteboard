#Source: http://talklikeaduck.denhaven2.com/2007/07/18/time-flies-while-youre-having-fun-testing

#class Test::Unit::TestCase                    # 1
  module TimeMachine

    def now_as(time)
      time_class = class << Time; self; end   # 5
      date_class = class << Date; self; end
      begin
        Time.class_eval do 
          @now_stack ||= []
          if @now_stack.empty?                # 10
            time_class.class_eval do
              alias_method :old_now, :now
              def now
                @now_stack.last.dup
              end                             # 15
            end
            date_class.class_eval do
              alias_method :old_today, :today
              def today
                Time.now.to_date              # 20
              end
            end
          end
          @now_stack.push(time.dup)
        end                                   # 25 
        yield
      ensure
        Time.class_eval do 
          @now_stack.pop
          if @now_stack.empty?                # 30
            date_class.class_eval {alias_method :today, :old_today}
            time_class.class_eval {alias_method :now, :old_now}
          end
        end
      end                                     # 35
    end
end
