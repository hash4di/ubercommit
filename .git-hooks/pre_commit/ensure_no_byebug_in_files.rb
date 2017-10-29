# Example configuration:
#
# EnsureNoByebugInFiles:
#   enabled: true
#   include:
#     - '**/*.rb'
module Overcommit::Hook::PreCommit
  class EnsureNoByebugInFiles < Base
    def run
      errors = []

      check_files.each do |file|
        errors << "#{file}: contains 'byebug'" if File.read(file) =~ /byebug/
      end

      return :fail, errors.join("\n") if errors.any?

      :pass
    end

    private

    def check_files
      applicable_files.reject do |file|
        File.basename(file) =~ /^Gemfile|ensure_no_byebug_in_files\.rb/
      end
    end
  end
end
