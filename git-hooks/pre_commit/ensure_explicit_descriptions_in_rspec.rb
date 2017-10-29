# Example configuration:
#
# EnsureExplicitDescriptionsInRspec:
#    enabled: true
#    include:
#      - 'spec/**/*.rb'
module Overcommit
  module Hook
    module PreCommit
      # Require descriptions on describe and context blocks
      class EnsureExplicitDescriptionsInRspec < Base
        BLOCK_NAMES = %i[describe context].freeze

        def run
          errors = detect_errors
          return :fail, errors.join("\n") unless errors.empty?

          :pass
        end

        private

        def detect_errors
          check_files.map do |file|
            file_contents = File.read(file)
            BLOCK_NAMES.map do |block_name|
              next unless file_contents.include?("#{block_name} do")
              [
                "#{file}: contains '#{block_name} do'",
                "(please use explicit description like: #{block_name} 'this block does' do)"
              ].join(' ')
            end
          end.flatten.compact
        end

        def check_files
          applicable_files.reject do |file|
            File.basename(file) =~ /^ensure_explicit_descriptions_in_rspec\.rb$/
          end
        end
      end
    end
  end
end
