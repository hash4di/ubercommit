# Example configuration:
#
# EnsureBetterArrayMatchingInRspec:
#   enabled: true
#   include:
#     - 'spec/**/*.rb'
module Overcommit::Hook::PreCommit
  class EnsureBetterArrayMatchingInRspec < Base
    def run
      warnings = detect_warnings
      return :warn, warnings.join("\n") unless warnings.empty?
      :pass
    end

    private

    def detect_warnings
      check_files.map do |file|
        file_contents = File.read(file)
        if file_contents.include?(' eq([])')
          "#{file}: contains ' eq([])' (can be replaced by ' be_empty')`"
        elsif file_contents =~ / eq\(\[(.{1,})\]\)/
          "#{file}: contains ' eq([#{$1}])' (can be replaced by ' contain_exactly(#{$1})')`"
        end
      end.compact
    end

    def check_files
      applicable_files.reject do |file|
        File.basename(file) =~ /^ensure_better_array_matching_in_rspec\.rb$/
      end
    end
  end
end
