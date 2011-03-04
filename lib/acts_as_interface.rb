require 'active_support'

#Include ActsAsInterface to easily define abstract methods
#Example: Superclass
# class Person
#   abstract_methods :dance, :eat
#   abstract_methods :sleep, :play, :visibility => :private
#   callbacks :prance
#
#   abstract_methods :foo, :for => :class
#   callbacks :france, :for => :class, :visibility => :protected
# end
#
# me = MyClass.new
# me.dance #raises NotImplementedError
# me.play #raises NoMethodError: private method `close_book` called
# me.send(:play) #calls empty method play
# me.prance #calls empty method prance
# Person.foo #raises NotImplementedError
#
#Example: ActiveRecord Module
# module ActsAsPerson
#   
#   # included in active record objects where abstracted methods can be either attributes of the model or defined by the model
#   def self.included(base)
#     base.instance_eval do
#       include ActsAsInterface
#       abstract_methods :name, :dance
#     end
#   end
#   
# end
class Object
  def define_abstract_method(abstract_method_name, options)
    model_columns = []
    error_on_column_load = false
    begin
      model_columns = respond_to?(:columns) ? columns : []
    rescue
      error_on_column_load = true
    end

    unless method_defined?(abstract_method_name) or error_on_column_load or model_columns.any? { |column| column.name.to_sym == abstract_method_name }
      define_method(abstract_method_name) do |*abstract_method_args|
        if options.has_key?(:default)
          options[:default]
        else 
          class_name = options[:for] == :class ? self : self.class
          raise NotImplementedError, "#{abstract_method_name} not defined for #{class_name}"
        end      
      end
    
      send(options[:visibility], abstract_method_name) if options[:visibility]
    end
  end
end

module ActsAsInterface

  def self.included(base)
    base.extend(ClassMethods)
  end    

  module ClassMethods
    def abstract_methods(*args)
      options = args.extract_options!
      args.each do |abstract_method_name|
        if options[:for] == :class
          (class << self; self; end).define_abstract_method(abstract_method_name, options)
        else
          define_abstract_method(abstract_method_name, options)
        end        
      end
    end
    
    def callbacks(*args)
      options = args.extract_options!
      options = {:default => nil}.merge(options)
      abstract_methods(*args.push(options))
    end
  end

end