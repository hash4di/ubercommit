# Example configuration:
#
# YarnLint:
#   enabled: true
#   include:
#     - '**/*.js'
module Overcommit
  module Hook
    module PreCommit
      # Run Yarn Lint check for javascript files
      class YarnLint < Base
        COMMAND = %w[yarn run lint].freeze

        def run
          result = execute(COMMAND)
          return :fail, result unless $CHILD_STATUS.success?
          :pass
        end
      end
    end
  end
end
