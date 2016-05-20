module Appsules

  # The point of this class is to determine the names of all of the classes and modules
  # that are defined in a particular piece of Ruby code.
  class DefinitionParser

    # sexp is an s-expression returned from Ripper
    # see http://ruby-doc.org/stdlib-2.0.0/libdoc/ripper/rdoc/Ripper.html
    def initialize(sexp)
      @sexp = sexp
    end

    def defined_classes_and_modules
      @class_and_module_names = []
      @current_scope = []
      search(@sexp)
      @class_and_module_names.uniq
    end

    private

    def search(sexp)
      if defining_a_class_or_module?(sexp)
        rest_of_sexp, class_or_module_name = figure_out_and_record_the_class_or_module_name(sexp)
        inside_scope(class_or_module_name) do
          keep_searching(rest_of_sexp)
        end
      else
        keep_searching(sexp)
      end
    end

    def keep_searching(sexp)
      sexp.each do |x|
        if x.is_a?(Array)
          search(x)
        end
      end
    end

    def inside_scope(class_or_module_name)
      @current_scope.push(class_or_module_name)
      yield
      @current_scope.pop
    end

    def defining_a_class_or_module?(sexp)
      (sexp.first == :module) || (sexp.first == :class)
    end

    def figure_out_and_record_the_class_or_module_name(sexp)
      _, constant_definition_sexp, *rest_of_sexp = sexp
      class_or_module_name = figure_out_the_class_or_module_name_from(constant_definition_sexp)
      record_the_fully_scoped_class_or_module_name
      return rest_of_sexp, class_or_module_name
    end

    def figure_out_the_class_or_module_name_from(constant_definition_sexp)
      @extracted_name = []
      collect_name_from(constant_definition_sexp)
      @extracted_name.join("::")
    end

    def record_the_fully_scoped_class_or_module_name
      fully_scoped_class_or_module_name = (@current_scope + @extracted_name).join("::")
      @class_and_module_names << fully_scoped_class_or_module_name
    end

    # These are examples of arrays that could be passed into the argument
    # constant_definition_sexp:
    #
    #   [:const_ref, [:@const, "Canada", [1, 7]]]
    #   [:const_ref, [:@const, "Ontario", [2, 9]]]
    #   [:const_ref, [:@const, "Ottawa", [3, 10]]]
    #   [:const_path_ref, [:var_ref, [:@const, "Quebec", [6, 8]]], [:@const, "Quebec", [6, 16]]]
    #   [:const_ref, [:@const, "UnitedStates", [10, 6]]]
    #   [:const_ref, [:@const, "Virginia", [11, 8]]]
    #   [:const_ref, [:@const, "Richmond", [12, 10]]]
    #   [:const_path_ref, [:const_path_ref, [:var_ref, [:@const, "UnitedStates", [17, 6]]], [:@const, "NorthCarolina", [17, 20]]], [:@const, "ElizabethCity", [17, 35]]]
    #   [:const_path_ref, [:var_ref, [:@const, "Canada", [25, 7]]], [:@const, "Manitoba", [25, 15]]]
    #   [:const_ref, [:@const, "Winnipeg", [26, 8]]]
    #   [:const_ref, [:@const, "NorthAmerica", [30, 6]]]
    #   [:const_ref, [:@const, "Bahamas", [31, 9]]]
    #   [:const_ref, [:@const, "Nassau", [32, 10]]]
    #   [:const_ref, [:@const, "Timey", [1, 13]]]
    #   [:const_ref, [:@const, "Wimey", [2, 15]]]
    #   [:const_ref, [:@const, "One", [1, 12]]]
    #   [:const_ref, [:@const, "Two", [5, 12]]]
    #   [:const_ref, [:@const, "OneClass", [2, 12]]]
    #   [:const_path_ref, [:var_ref, [:@const, "Foo", [1, 12]]], [:@const, "Bar", [1, 17]]]
    #   [:const_ref, [:@const, "OneMod", [1, 13]]]
    #   [:const_ref, [:@const, "TwoMod", [2, 13]]]
    #   [:const_ref, [:@const, "Space", [1, 13]]]
    #   [:const_ref, [:@const, "Time", [2, 14]]]
    #
    def collect_name_from(constant_definition_sexp)
      constant_definition_sexp.each do |x|
        if x.is_a?(Array)
          if x[0] == :@const
            @extracted_name << x[1]
          else
            collect_name_from(x)
          end
        end
      end
    end

  end
end
