require "helper"

class AttributeActsAsInterfaceTest < Test::Unit::TestCase

  class InterfacedClass
    include ActsAsInterface
    
    def existing_method
      true
    end
    
    class << self
      def existing_class_method
        true
      end
    end
    
    abstract_methods :im, :existing_method
    abstract_methods :private_im, :visibility => :private
    abstract_methods :im_with_default, :default => nil
    callbacks :icb

    abstract_methods :cm, :existing_class_method, :for => :class
    abstract_methods :private_cm, :visibility => :private, :for => :class
    abstract_methods :cm_with_default, :default => nil, :for => :class
    callbacks :ccb, :for => :class
  end
  
  class ChildOfInterfacedClass < InterfacedClass
    def im(word)
      "hello #{word}"
    end
    
    class << self
      def cm(word)
        "#{word} world"
      end
    end
  end
  
  context "with instance methods" do
    setup do
      @ic = InterfacedClass.new
    end
    
    should "raise with no default" do
      assert_raise(NotImplementedError) { @ic.im }
    end
    
    should "scope visibility if passed visibility option" do
      assert_raise(NoMethodError) { @ic.private_im }
      assert_raise(NotImplementedError) { @ic.send(:private_im) }
    end
    
    should "return default if passed default option" do
      assert_equal nil, @ic.im_with_default
    end
    
    should "return nil if callback" do
      assert_equal nil, @ic.icb
    end
    
    should "not override existing methods" do
      assert_equal true, @ic.existing_method
    end
    
    context "child class" do
      setup do
        @child = ChildOfInterfacedClass.new
      end
      
      should "be allowed to override abstracted method" do
        assert_equal "hello world", @child.im('world')
      end
    end    
  end
  
  context "with class methods" do
    should "raise with no default" do
      assert_raise(NotImplementedError) { InterfacedClass.cm }
    end
    
    should "scope visibility if passed visibility option" do
      assert_raise(NoMethodError) { InterfacedClass.private_cm }
      assert_raise(NotImplementedError) { InterfacedClass.send(:private_cm) }
    end
    
    should "return default if passed default option" do
      assert_equal nil, InterfacedClass.cm_with_default
    end
    
    should "return nil if callback" do
      assert_equal nil, InterfacedClass.ccb
    end
    
    should "not override existing methods" do
      assert_equal true, InterfacedClass.existing_class_method
    end
    
    context "child class" do
      should "be allowed to override abstracted method" do
        assert_equal "wayne's world", ChildOfInterfacedClass.cm("wayne's")
      end
    end
  end  
  
  
end