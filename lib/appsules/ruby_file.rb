require 'ripper'

module Appsules
  class RubyFile

    def initialize(filename)
      @filename = filename
      @definition_parser = DefinitionParser.new(as_sexp)
    end

    def defined_helpers
      @definition_parser.defined_classes_and_modules.select do |x|
        x.ends_with?('Helper')
      end
    end

    private

    def as_sexp
      Ripper.sexp(file_contents)
    end

    def file_contents
      IO.read(@filename)
    end

  end
end
