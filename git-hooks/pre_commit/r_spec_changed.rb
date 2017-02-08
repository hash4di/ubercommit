# Example configuration:
#
# RSpecChanged:
#   enabled: true
#   include:
#     - '**/*.rb'
module Overcommit::Hook::PreCommit
  class RSpecChanged < Base
    BASE_COMMAND = %w[spring rspec].freeze

    def run
      result = execute(BASE_COMMAND, args: applicable_files)
      return :fail, result.stdout unless result.success?
      :pass
    end
  end
end
