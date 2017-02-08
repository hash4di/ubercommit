# Example configuration:
#
# EnsureNoFileExistRailsRootJoinInFiles:
#   enabled: true
#   include:
#     - 'spec/**/*.rb'
module Overcommit::Hook::PreCommit
  class EnsureNoFocusInSpecs < Base
    def run
      errors = files_with_focus.map { |file| "#{file}: contains ', :focus '`" }
      if errors.empty?
        :pass # :ok, right? :)
      else
        [:fail, errors.join("\n")]
      end
    end

    private

    def files_with_focus
      applicable_files.select { |file| File.read(file).include?(', :focus') }
    end
  end
end
