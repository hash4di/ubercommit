# Example configuration:
#
# EnsureUsingFactoryBotListsInSpecs:
#   enabled: true
#   include:
#     - 'spec/**/*.rb'
module Overcommit
  module Hook
    module PreCommit
      FACTORY_METHODS = %w[create build].freeze
      DELIMITERS = [' ', '('].freeze

      # Warns about '.times { create' and similar in specs in favor of creating factory lists
      class EnsureUsingFactoryBotListsInSpecs < Base
        def run
          return :pass if warnings.empty?
          [:warn, warnings.join("\n")]
        end

        private

        def warnings
          @warnings ||= applicable_files.map do |file|
            file_contents = File.read(file)
            FACTORY_METHODS.map do |factory_method|
              DELIMITERS.map do |delimiter|
                if file_contents.include?(".times { #{factory_method}#{delimiter}")
                  "#{file}: contains '.times { #{factory_method}#{delimiter}', it should be replaced with '#{factory_method}_list#{delimiter}'"
                end
              end
            end
          end
        end
      end
    end
  end
end
