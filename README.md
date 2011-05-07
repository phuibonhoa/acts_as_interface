# acts\_as\_interface

## INSTALL

    gem install acts_as_interface

## DESCRIPTION

In the spirit of self documenting code, `acts_as_interface` allows you to easily define `abstract_methods` and callbacks just by listing them at the top of a superclass or module.  Child classes or classes that include the module must implement abstract_methods or a `NotImplementedError` is raised when the method is called.

## EXAMPLE
    class Person
      include acts_as_interface
  
      # all subclasses are expected to define id and worth
      abstract_methods :id 
      abstract_methods :worth, :visibility => :private
  
      # defines an empty method called before_sleep, which I call in sleep.  Subclasses can override before_sleep if they need to.
      callbacks :before_sleep 
  
      def sleep
        before_sleep
        close_eyes
        dream
      end
    end

    class Student < Person
      def id
        student_id
      end
  
      def before_sleep
        set_alarm
      end
  
      private  
      def worth
        0
      end
    end

    class Employee < Person
      def id
        employee_number
      end
  
      private
      def worth
        salary
      end
    end

## OPTIONS

Both `abstract_methods` and `callbacks` take options that accept the following keys
 
visibility - :private, :protected, or :public (default is public)

    abstract_methods :internal_counter, :visibility => private

for - :class or :instance (default is instance)  - is the method a class method or an instance method?
 
    abstract_methods :category, :for => :class

## USING WITH DIFFERENT TYPES OF INHERITANCE

### SUBCLASSING

    class Person
      include acts_as_interface
      abstract_methods :dance, :eat
    end
    
    class Student < Person
      # define dance and eat here
    end
    
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
      
      # define name and dance here
      # still works if name or dance is previously defined (ie if name were an attribute of the Student model - t.string :name)
    end
  
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
      acts_as_person # apply interface
    end
  
  
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

