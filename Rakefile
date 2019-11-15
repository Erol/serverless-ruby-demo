task :console do
  system('docker-compose run --rm lambda irb')
end

task :build do
  system('docker-compose run --rm lambda bundle install --clean --standalone --path vendor/bundle')
end

task :deploy do
  system('docker-compose run --rm serverless sls deploy -v')
end

namespace :deploy do
  task :list do
    system('docker-compose run --rm serverless sls deploy list')
  end
end
