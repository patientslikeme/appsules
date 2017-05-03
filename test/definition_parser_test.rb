require_relative 'appsules_test_helper'
require_relative '../lib/appsules/definition_parser'
require 'ripper'
require "active_support/core_ext"

require 'pry'

class DefinitionParserTest < ActiveSupport::TestCase

  test "returns an empty array when s-expression is empty" do
    parser = Appsules::DefinitionParser.new([])
    assert_equal [], parser.defined_classes_and_modules
  end

  def ruby_that_defines_one_class
    Ripper.sexp(<<-RUBY)
      # arbitrary comment
      class OneClass
        def arbitrary
          return 7 + 8
        end
      end
    RUBY
  end

  test "when one class is defined, returns an array with that class name" do
    parser = Appsules::DefinitionParser.new(ruby_that_defines_one_class)
    assert_equal ["OneClass"], parser.defined_classes_and_modules
  end

  def ruby_that_defines_two_classes
    Ripper.sexp(<<-RUBY)
      class One
        ONE = 1  # let's throw in a constant for good measure
      end

      class Two
        TWO = 2  # let's throw in a constant for good measure
      end
    RUBY
  end

  test "when two classes are defined, returns an array with those class names" do
    parser = Appsules::DefinitionParser.new(ruby_that_defines_two_classes)
    assert_equal ["One", "Two"], parser.defined_classes_and_modules
  end

  def ruby_that_defines_two_modules
    Ripper.sexp(<<-RUBY)
      module OneMod; end
      module TwoMod; end
    RUBY
  end

  test "when two modules are defined, returns an array with those module names" do
    parser = Appsules::DefinitionParser.new(ruby_that_defines_two_modules)
    assert_equal ["OneMod", "TwoMod"], parser.defined_classes_and_modules
  end

  def ruby_that_defines_a_constant_value
    Ripper.sexp(<<-RUBY)
      SOME_CONSTANT = 299792458
    RUBY
  end

  test "when a constant value is defined, its name is not returned" do
    parser = Appsules::DefinitionParser.new(ruby_that_defines_a_constant_value)
    assert_equal [], parser.defined_classes_and_modules
  end

  def ruby_that_reopens_a_class
    Ripper.sexp(<<-RUBY)
      class Number
        ONE = 1  # let's throw in a constant for good measure
      end

      class Number
        TWO = 2  # let's throw in a constant for good measure
      end
    RUBY
  end

  test "when a class is reopened, returns an array with the class name not duplicated" do
    parser = Appsules::DefinitionParser.new(ruby_that_reopens_a_class)
    assert_equal ["Number"], parser.defined_classes_and_modules
  end

  def ruby_that_defines_a_class_in_a_module
    Ripper.sexp(<<-RUBY)
      module Space
        class Time
          def event
          end
        end
      end
    RUBY
  end

  test "when a class in a module is defined, returns an array with the module name and the fully namespaced class name" do
    parser = Appsules::DefinitionParser.new(ruby_that_defines_a_class_in_a_module)
    assert_equal ["Space", "Space::Time"], parser.defined_classes_and_modules
  end

  def ruby_that_defines_a_module_in_a_module
    Ripper.sexp(<<-RUBY)
      module Timey
        module Wimey
          def event
          end
        end
      end
    RUBY
  end

  test "when a module in a module is defined, returns an array with fully namespaced module names" do
    parser = Appsules::DefinitionParser.new(ruby_that_defines_a_module_in_a_module)
    assert_equal ["Timey", "Timey::Wimey"], parser.defined_classes_and_modules
  end

  def ruby_that_defines_a_namespaced_class
    Ripper.sexp(<<-RUBY)
      class Foo::Bar
        def some
          "thing"
        end
      end
    RUBY
  end

  test "when a namespaced class is defined, returns an array with the fully namespaced class name" do
    parser = Appsules::DefinitionParser.new(ruby_that_defines_a_namespaced_class)
    assert_equal ["Foo::Bar"], parser.defined_classes_and_modules
  end

  def ruby_that_defines_many_namespaced_classes_and_modules
    Ripper.sexp(<<-RUBY.strip_heredoc)
      module Canada
        module Ontario
          class Ottawa
          end
        end
        class Quebec::Quebec
        end
      end

      class UnitedStates
        class Virginia
          class Richmond
          end
        end
      end

      class UnitedStates::NorthCarolina::ElizabethCity
        SOME_CONSTANT = 77

        def some_method
          78
        end
      end

      module Canada::Manitoba
        class Winnipeg
        end
      end

      class NorthAmerica
        module Bahamas
          class Nassau
          end
        end
      end
    RUBY
  end

  def sexp_reference_for_ruby_that_defines_many_namespaced_classes_and_modules
    [:program,
     [[:module,
       [:const_ref, [:@const, "Canada", [1, 7]]],
       [:bodystmt,
        [[:void_stmt],
         [:module,
          [:const_ref, [:@const, "Ontario", [2, 9]]],
          [:bodystmt,
           [[:void_stmt],
            [:class,
             [:const_ref, [:@const, "Ottawa", [3, 10]]],
             nil,
             [:bodystmt, [[:void_stmt]], nil, nil, nil]]],
           nil,
           nil,
           nil]],
         [:class,
          [:const_path_ref,
           [:var_ref, [:@const, "Quebec", [6, 8]]],
           [:@const, "Quebec", [6, 16]]],
          nil,
          [:bodystmt, [[:void_stmt]], nil, nil, nil]]],
        nil,
        nil,
        nil]],
      [:class,
       [:const_ref, [:@const, "UnitedStates", [10, 6]]],
       nil,
       [:bodystmt,
        [[:void_stmt],
         [:class,
          [:const_ref, [:@const, "Virginia", [11, 8]]],
          nil,
          [:bodystmt,
           [[:void_stmt],
            [:class,
             [:const_ref, [:@const, "Richmond", [12, 10]]],
             nil,
             [:bodystmt, [[:void_stmt]], nil, nil, nil]]],
           nil,
           nil,
           nil]]],
        nil,
        nil,
        nil]],
      [:class,
       [:const_path_ref,
        [:const_path_ref,
         [:var_ref, [:@const, "UnitedStates", [17, 6]]],
         [:@const, "NorthCarolina", [17, 20]]],
        [:@const, "ElizabethCity", [17, 35]]],
       nil,
       [:bodystmt,
        [[:void_stmt],
         [:assign,
          [:var_field, [:@const, "SOME_CONSTANT", [18, 2]]],
          [:@int, "77", [18, 18]]],
         [:def,
          [:@ident, "some_method", [20, 6]],
          [:params, nil, nil, nil, nil, nil, nil, nil],
          [:bodystmt, [[:@int, "78", [21, 4]]], nil, nil, nil]]],
        nil,
        nil,
        nil]],
      [:module,
       [:const_path_ref,
        [:var_ref, [:@const, "Canada", [25, 7]]],
        [:@const, "Manitoba", [25, 15]]],
       [:bodystmt,
        [[:void_stmt],
         [:class,
          [:const_ref, [:@const, "Winnipeg", [26, 8]]],
          nil,
          [:bodystmt, [[:void_stmt]], nil, nil, nil]]],
        nil,
        nil,
        nil]],
      [:class,
       [:const_ref, [:@const, "NorthAmerica", [30, 6]]],
       nil,
       [:bodystmt,
        [[:void_stmt],
         [:module,
          [:const_ref, [:@const, "Bahamas", [31, 9]]],
          [:bodystmt,
           [[:void_stmt],
            [:class,
             [:const_ref, [:@const, "Nassau", [32, 10]]],
             nil,
             [:bodystmt, [[:void_stmt]], nil, nil, nil]]],
           nil,
           nil,
           nil]]],
        nil,
        nil,
        nil]]]]
  end

  test "when many namespaces classes and modules are defined, returns an array with fully namespaced names" do
    assert_equal sexp_reference_for_ruby_that_defines_many_namespaced_classes_and_modules, ruby_that_defines_many_namespaced_classes_and_modules
    parser = Appsules::DefinitionParser.new(ruby_that_defines_many_namespaced_classes_and_modules)
    expected = [ "Canada",
                 "Canada::Ontario",
                 "Canada::Ontario::Ottawa",
                 "Canada::Quebec::Quebec",
                 "UnitedStates",
                 "UnitedStates::Virginia",
                 "UnitedStates::Virginia::Richmond",
                 "UnitedStates::NorthCarolina::ElizabethCity",
                 "Canada::Manitoba",
                 "Canada::Manitoba::Winnipeg",
                 "NorthAmerica",
                 "NorthAmerica::Bahamas",
                 "NorthAmerica::Bahamas::Nassau" ]
    assert_equal expected, parser.defined_classes_and_modules
  end

end
