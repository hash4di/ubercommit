# Example configuration:
#
# EnsureNoFileExistRailsRootJoinInFiles:
#   enabled: true
#   include:
#     - '**/*.rb'
module Overcommit
  module Hook
    module PreCommit
      # Prevent long syntax when checking Rails paths
      class EnsureNoFileExistRailsRootJoinInFiles < Base
        def run
          errors = detect_errors
          return :fail, errors.join("\n") if errors.any?
          :pass
        end

        private

        def detect_errors
          check_files.map do |file|
            next unless File.read(file) =~ /File\.exist\?.*Rails\.root\.join/
            [
              "#{file}: contains 'File.exist?(Rails.root.join(*))'",
              "(can be replaced by 'Rails.root.join(*).exist?')"
            ].join(' ')
          end.compact
        end

        def check_files
          applicable_files.reject do |file|
            File.basename(file) =~ /^ensure_no_file_exist_rails_root_join_in_files\.rb$/
          end
        end
      end
    end
  end
end
