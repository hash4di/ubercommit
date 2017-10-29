# Example configuration:
#
# EnsureNoRedundantBlockMethodAttributesInFiles:
#   enabled: true
#   include:
#     - '**/*.rb'
module Overcommit
  module Hook
    module PreCommit
      # Prevent redundant block methods
      class EnsureNoRedundantBlockMethodAttributesInFiles < Base
        def run
          errors = []

          check_files.each do |file|
            if File.read(file) =~ /\(&_\)/
              errors << "#{file}: contains method with '(&_)' (can be removed)"
            end
          end

          return :fail, errors.join("\n") if errors.any?

          :pass
        end

        private

        def check_files
          applicable_files.reject do |file|
            File.basename(file) =~ /^ensure_no_redundant_block_method_attributes_in_files\.rb$/
          end
        end
      end
    end
  end
end
