# Example configuration:
#
# EnsureNoFileExistRailsRootJoinInFiles:
#   enabled: true
#   include:
#     - '**/*.rb'
module Overcommit::Hook::PreCommit
  class EnsureNoFileExistRailsRootJoinInFiles < Base
    def run
      errors = []

      check_files.each do |file|
        if File.read(file) =~ /File\.exist\?.*Rails\.root\.join/
          errors << "#{file}: contains 'File.exist?(Rails.root.join(*))' (can be replaced by 'Rails.root.join(*).exist?')"
        end
      end

      return :fail, errors.join("\n") if errors.any?

      :pass
    end

    private

    def check_files
      applicable_files.reject do |file|
        File.basename(file) =~ /^ensure_no_file_exist_rails_root_join_in_files\.rb$/
      end
    end
  end
end
