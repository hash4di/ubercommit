# Example configuration:
#
# EnsureNoBindingPryInFiles:
#   enabled: true
#   include:
#     - '**/*.rb'
module Overcommit
  module Hook
    module PreCommit
      # Prevent 'binding.pry' in files
      class EnsureNoBindingPryInFiles < Base
        def run
          errors = []

          check_files.each do |file|
            if File.read(file) =~ /binding\.pry/
              errors << "#{file}: contains 'binding.pry'`"
            end
          end

          return :fail, errors.join("\n") if errors.any?

          :pass
        end

        private

        def check_files
          applicable_files.reject do |file|
            File.basename(file) =~ /^ensure_no_binding_pry_in_files\.rb$/
          end
        end
      end
    end
  end
end
