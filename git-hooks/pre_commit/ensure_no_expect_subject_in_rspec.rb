# Example configuration:
#
# EnsureNoExpectSubjectInRspec:
#   enabled: true
#   include:
#     - 'spec/**/*.rb'
module Overcommit::Hook::PreCommit
  class EnsureNoExpectSubjectInRspec < Base
    def run
      errors = detect_errors
      return :fail, errors.join("\n") unless errors.empty?

      :pass
    end

    private

    def detect_errors
      check_files.map do |file|
        file_contents = File.read(file)
        if file_contents.include?(' expect(subject).')
          "#{file}: contains ' expect(subject).' (can be replaced by ' is_expected.')"
        end
      end.compact
    end

    def message_with_suggestion(file, verb, replace_verb, matcher, negated_matcher, ending)
      ["#{file}: contains '#{verb} #{matcher}#{ending}' (can be replaced by '#{replace_verb} #{negated_matcher}#{ending}')"]
    end

    def check_files
      applicable_files.reject do |file|
        File.basename(file) =~ /^ensure_no_expect_subject_in_rspec\.rb$/
      end
    end
  end
end
