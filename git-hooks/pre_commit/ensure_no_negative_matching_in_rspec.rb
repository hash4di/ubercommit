module Overcommit::Hook::PreCommit
  class EnsureNoNegativeMatchingInRspec < Base
    MATCHERS = {
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
    VERBS = {
      to_not: :to,
      not_to: :to,
      and_not: :and
    }.freeze

    def run
      errors = detect_errors
      if errors.empty?
        warnings = detect_warnings
        return :warn, warnings.join("\n") unless warnings.empty?
      else
        return :fail, errors.join("\n")
      end

      :pass
    end

    private

    def detect_errors
      check_files.each do |file|
        file_contents = File.read(file)
        MATCHERS.each do |matcher, negated_matcher|
          VERBS.map do |verb, replace_verb|
            if file_contents.include?("not_to #{matcher}")
              ["#{file}: contains '#{verb} #{matcher}' (can be replaced by '#{replace_verb} #{negated_matcher}')"]
            end
          end
        end
      end.flatten.compact
    end

    def detect_warnings
      check_files.each do |file|
        file_contents = File.read(file)
        VERBS.keys.map do |verb|
          if file_contents.include?(".#{verb} ")
            ["#{file}: contains '.#{verb} '`"]
          end
        end
      end.flatten.compact
    end

    def check_files
      applicable_files.reject do |file|
        File.basename(file) =~ /^ensure_no_negative_matching_in_rspec\.rb$/
      end
    end
  end
end
