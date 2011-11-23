namespace :db do
  desc "Loads initial database models for the current environment."
  task :populate => :environment do
    Dir[File.join(Rails.root, 'db', 'fixtures', '*.rb')].sort.each { |fixture| load fixture }
    Dir[File.join(Rails.root, 'db', 'fixtures', Rails.env, '*.rb')].sort.each { |fixture| load fixture }
  end
end
