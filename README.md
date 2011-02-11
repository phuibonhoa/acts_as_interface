# acts\_as\_interface

## INSTALL

    gem install acts_as_interface

## DESCRIPTION

In the spirit of self documenting code, `acts_as_interface` allows you to easily define `abstract_methods` and callbacks just by listing them at the top of a superclass or module.  Child classes or classes that include the module must implement abstract_methods or a `NotImplementedError` is raised when the method is called.

## EXAMPLES

### SUPERCLASS

    class Person
      include acts_as_interface
      
      abstract_methods :dance, :eat
      abstract_methods :sleep, :play, :visibility => :private
      callbacks :prance
    
      abstract_methods :foo, :for => :class
      callbacks :france, :for => :class, :visibility => :protected
    end
    
    class Student < Person
      
    end
    
    me = Student.new
    me.dance ## => raises NotImplementedError
    
    me.play ## => raises NoMethodError: private method `play` called
    me.send(:play) ## => raises NotImplementedError
    
    me.prance ## calls empty method prance
    
    Student.foo ## => raises NotImplementedError


### MODULE (on include)

    module ActsAsPerson    
      def self.included(base)
        base.instance_eval do
          include ActsAsInterface
          abstract_methods :name, :dance
        end
      end
    end
  
    class Student < ActiveRecord::Base
      include acts_as_person
      
      #name is an attribute (ie t.string :name)
    end
    
    student = Student.first
    student.name ## works as usual
    student.dance ## => raises NotImplementedError
  
### MODULE (from method call)

    module ActsAsPerson    
      module ClassMethods
        def acts_as_person
          include ActsAsInterface
          abstract_methods :name, :dance
        end
      end
      
      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  
    class Student < ActiveRecord::Base
      include acts_as_person
      
      #include or invoke modules that defines name but not dance
      
      acts_as_person ## apply interface
    end
    
    student = Student.first
    student.name ## works as usual
    student.dance ## => raises NotImplementedError
  
  
## Credits

![BookRenter.com Logo](http://assets0.bookrenter.com/images/header/bookrenter_logo.gif "BookRenter.com")

ActsAsInterface is currently maintained by [Philippe Huibonhoa](http://github.com/phuibonhoa) and funded by [BookRenter.com](http://www.bookrenter.com "BookRenter.com").

## CONTRIBUTING

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## COPYRIGHT

Copyright (c) 2011 Philippe Huibonhoa. See LICENSE.txt for
further details.

