# Example configuration:
#
# WarnAboutSend:
#   enabled: true
#   include:
#     - '**/*.rb'
module Overcommit
  module Hook
    module PreCommit
      # Warn about send which in most cases can be replaced with `.public_send(`
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
          return :warn, warnings.join("\n") if warnings.any?
          :pass
        end

        private

        def warnings
          check_files.map do |file|
            file_contents = File.read(file)
            OCCURENCES.map do |occurence|
              next unless file_contents.include?(occurence)
              "#{file}: contains '#{occurence}' (can be replaced with '.public_send('"
            end.compact
          end.flatten
        end

        def check_files
          applicable_files.reject do |file|
            File.basename(file) =~ /^warn_about_send\.rb$/
          end
        end
      end
    end
  end
end
