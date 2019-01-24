# Example configuration:
#
# WarnAboutUsingExists:
#   enabled: true
#   include:
#     - '**/*.rb'
#     - '**/*.slim'
#     - '**/*.erb'
#     - '**/*.rake'
module Overcommit
  module Hook
    module PreCommit
      # Warns about '.exists?' which in some cases can be replaced with '.any?' for speed
      class WarnAboutUsingExists < Base
        def run
          return :pass if warnings.empty?
          [:warn, warnings.join("\n")]
        end

        private

        def warnings
          @warnings ||= applicable_files.map do |file|
            if File.read(file).include?('.exists?')
              "#{file}: contains '.exists?', you may want to check if '.any?' can be used"
            end
          end
        end
      end
    end
  end
end
