# Example configuration:
#
# GitSecrets:
#   enabled: true
module Overcommit
  module Hook
    module PreCommit
      # Run git-secrets pre-commit checks
      class GitSecrets < Base
        def run
          result = `git secrets --pre_commit_hook -- "#{check_files.join('" "')}"`

          return :fail, result unless $CHILD_STATUS.success?

          :pass
        end

        private

        def check_files
          applicable_files.reject do |file|
            File.basename(file) =~ /^git_secrets\.rb$/
          end
        end
      end
    end
  end
end
