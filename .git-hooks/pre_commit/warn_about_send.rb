# Example configuration:
#
# WarnAboutSend:
#   enabled: true
#   include:
#     - '**/*.rb'
module Overcommit::Hook::PreCommit
  class WarnAboutSend < Base
    OCCURENCES = [
      ' send(',
      '.send(',
      '.send :',
      '.send "',
      ".send '",
      ' __send__(',
      '.__send__(',
      '.__send__ :',
      '.__send__ "',
      ".__send__ '"
    ].freeze

    def run
      warnings = []

      check_files.each do |file|
        file_contents = File.read(file)
        OCCURENCES.each do |occurence|
          if file_contents.include?(occurence)
            warnings << "#{file}: contains '#{occurence}' (can be replaced with '.public_send('"
          end
        end
      end

      return :warn, warnings.join("\n") if warnings.any?

      :pass
    end

    private

    def check_files
      applicable_files.reject do |file|
        File.basename(file) =~ /^warn_about_send\.rb$/
      end
    end
  end
end
