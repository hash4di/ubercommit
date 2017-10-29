# Example configuration:
#
# EnsureNoNegativeMatchingInRspec:
#   enabled: true
#   include:
#     - 'spec/**/*.rb'
module Overcommit
  module Hook
    module PreCommit
      # Prevent negative RSpec matching as it causes lots of problems
      class EnsureNoNegativeMatchingInRspec < Base
        ERROR_MATCHERS = {
          have_content: :have_no_content,
          have_text: :have_no_text,
          include: :not_include,
          have_selector: :have_no_selector,
          have_css: :have_no_css,
          have_xpath: :have_no_xpath,
          have_link: :have_no_link,
          have_field: :have_no_field,
          be_present: :be_blank,
          change: :not_change
        }.freeze
        EOL_WARN_MATCHERS = {
          be_nil: :be_present,
          be_present: :be_empty,
          be_empty: :be_present
        }.freeze
        VERBS = {
          to_not: :to,
          not_to: :to,
          and_not: :and
        }.freeze
        ENDINGS = [
          ' ',
          '(',
          '{'
        ].freeze

        def run
          errors = detect_errors
          return :fail, errors.join("\n") unless errors.empty?
          warnings = detect_warnings
          return :warn, warnings.join("\n") unless warnings.empty?
          :pass
        end

        private

        def detect_errors
          check_files.map do |file|
            file_contents = File.read(file)
            ERROR_MATCHERS.map do |matcher, negated_matcher|
              VERBS.map do |verb, replace_verb|
                ENDINGS.map do |ending|
                  next unless file_contents.include?(".#{verb} #{matcher}#{ending}")
                  message_with_suggestion(file, verb, replace_verb, matcher, negated_matcher, ending)
                end
              end
            end
          end.flatten.compact
        end

        def detect_warnings
          check_files.map do |file|
            file_contents = File.read(file)
            warnings_with_replacement(file, file_contents) +
              warnings_without_replacement(file, file_contents)
          end.flatten.compact
        end

        def warnings_with_replacement(file, file_contents)
          VERBS.map do |verb, replace_verb|
            EOL_WARN_MATCHERS.map do |matcher, negated_matcher|
              next unless file_contents =~ /\.#{verb} #{matcher}$/
              message_with_suggestion(file, verb, replace_verb, matcher, negated_matcher, '')
            end
          end
        end

        def warnings_without_replacement(file, file_contents)
          VERBS.keys.map do |verb|
            next unless file_contents.include?(".#{verb} ")
            ["#{file}: contains '.#{verb} '`"]
          end
        end

        # rubocop:disable ParameterLists
        def message_with_suggestion(file, verb, replace_verb, matcher, negated_matcher, ending)
          [
            "#{file}: contains '#{verb} #{matcher}#{ending}'",
            "(can be replaced by '#{replace_verb} #{negated_matcher}#{ending}')"
          ].join(' ')
        end

        def check_files
          applicable_files.reject do |file|
            File.basename(file) =~ /^ensure_no_negative_matching_in_rspec\.rb$/
          end
        end
      end
    end
  end
end
