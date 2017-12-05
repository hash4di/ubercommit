# Example configuration:
#
# GitSecrets:
#   enabled: true
module Overcommit
  module Hook
    module CommitMsg
      # Run git-secrets commit-msg checks
      class GitSecrets < Base
        def run
          result = `git secrets --commit_msg_hook -- "#{check_files.join('" "')}"`

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
