namespace :deploy do
  STAGING_APP    = 'ypn'
  PRODUCTION_APP = 'buildersbidnetwork'

  iso_date = Time.now.strftime('%Y-%m-%dT%H%M%S')

  def run(*cmd)
    puts ">>> #{cmd}"
    system(*cmd)
    raise "Command #{cmd.inspect} failed!" unless $?.success?
  end

  def maint(app, state = "on")
    puts "Putting #{app} into maintenance mode: #{state.upcase}..."
    run "heroku maintenance:#{state} --app #{app}"
  end

  def migrate(app)
    puts "Migrating #{app}..."
    run "heroku rake db:migrate --app #{app}"
  end

  desc "Tag HEAD and deploy to staging."
  task :stage do
    tag_name = "staged-#{iso_date}"
    puts "Tagging #{tag_name}..."
    run "git tag #{tag_name}"
    run "git push origin #{tag_name}"
    maint(STAGING_APP)
    puts "Pushing #{tag_name} to STAGE..."
    run "git push git@heroku.com:#{STAGING_APP}.git #{tag_name}^{}:master"
    migrate(STAGING_APP)
    puts "Setting DEPLOYED_VERSION to #{tag_name} on STAGE..."
    run "heroku config:add DEPLOYED_VERSION=#{tag_name} --app #{STAGING_APP}"
    maint(STAGING_APP, "off")
  end

  desc "Promote the last staged build to production."
  task :promote do
    releases = `git tag`.split("\n").select { |t| t[0..6] == 'staged-' }.sort
    staged_release = releases.last
    if staged_release
      maint(PRODUCTION_APP)
      puts "Backing up production database..."
      run "heroku pgbackups:capture --app #{PRODUCTION_APP}"
      puts "Pushing #{staged_release} to PROD..."
      run "git push git@heroku.com:#{PRODUCTION_APP}.git #{staged_release}^{}:master"
      migrate(PRODUCTION_APP)
      maint(PRODUCTION_APP, "off")
    else
      puts "No staged release tags found"
    end
  end
end
