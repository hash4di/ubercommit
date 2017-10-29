# Example configuration:
#
# EnsureNoPluckIdInFiles:
#   enabled: true
#   include:
#     - '**/*.rb'
module Overcommit
  module Hook
    module PreCommit
      # Prevent '.pluck(:id)' as 'ids' is shorter
      class EnsureNoPluckIdInFiles < Base
        def run
          errors = []

          check_files.each do |file|
            if File.read(file) =~ /\.pluck\(:id\)/
              errors << "#{file}: contains '.pluck(:id)' (can be replaced by '.ids')"
            end
          end

          return :fail, errors.join("\n") if errors.any?

          :pass
        end

        private

        def check_files
          applicable_files.reject do |file|
            File.basename(file) =~ /^ensure_no_pluck_id_in_files\.rb$/
          end
        end
      end
    end
  end
end
