desc "Run all of your sneakers tasks"
task :amqp => :environment do
  OrderWorker
  # MyRandomWorker
  # MyOtherSneakersWorker
  Rake::Task["sneakers:run"].invoke
end