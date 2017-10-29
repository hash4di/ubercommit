# Example configuration:
#
# RSpecChanged:
#   enabled: true
#   include:
#     - '**/*.rb'
module Overcommit
  module Hook
    module PreCommit
      # Run changed rspec files
      class RSpecChanged < Base
        BASE_COMMAND = %w[spring rspec].freeze

        def run
          result = execute(BASE_COMMAND, args: applicable_files)
          return :fail, result.stdout unless result.success?
          :pass
        end
      end
    end
  end
end
