unless Rails.env.production?
  require "rspec/core/rake_task"
  # require "coveralls/rake/task"

  # Coveralls::RakeTask.new

  namespace :ci do
    desc "Run all tests and send report to Coveralls"
    task tests: [:spec]
  end
end
