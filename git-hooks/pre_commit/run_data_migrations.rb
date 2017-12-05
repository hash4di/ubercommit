# Example configuration:
#
# RunDataMigrations:
#   enabled: true
#   include:
#     - 'db/migrate_data/*.rb'
module Overcommit
  module Hook
    module PreCommit
      # Run data migrations
      class RunDataMigrations < Base
        def run
          result = `rake "db:migrate_data_valid[#{data_migrations.join(',')}]"`

          return :fail, result unless $CHILD_STATUS.success?

          :pass
        end

        private

        def data_migrations
          check_files.map { |file| File.basename(file)[15..-1].gsub('.rb', '') }
        end

        def check_files
          applicable_files.reject do |file|
            File.basename(file) =~ /^run_data_migrations\.rb/
          end
        end
      end
    end
  end
end
