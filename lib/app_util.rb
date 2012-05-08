module MyActiveRecordExtensions
    def self.included(base)
      base.extend(ClassMethods)
    end

    # add instance methods here
    # for example:
    # def foo
    # => "foo"
    # end
    
    

  module ClassMethods
        # add class methods here
    def random
      if (c = count) != 0
        find(:first, :offset =>rand(c))
      end
    end
 end
end

#include the extension
ActiveRecord::Base.send(:include, MyActiveRecordExtensions)