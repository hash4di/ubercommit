module Overcommit::Hook::PreCommit
  class YarnLint < Base
    COMMAND = %w[yarn run lint].freeze

    def run
      result = execute(COMMAND)
      return :fail, result unless $CHILD_STATUS.success?
      :pass
    end
  end
end
