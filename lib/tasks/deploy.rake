namespace :deploy do
  STAGING_APP    = 'ypn'
  PRODUCTION_APP = 'buildersbidnetwork'

  iso_date = Time.now.strftime('%Y-%m-%dT%H%M%S')

  def run(*cmd)
    puts ">>> #{cmd}"
    system(*cmd)
    raise "Command #{cmd.inspect} failed!" unless $?.success?
  end

  desc "Tag HEAD and deploy to staging."
  task :stage do
    tag_name = "staged-#{iso_date}"
    run "git tag #{tag_name}"
    run "git push origin #{tag_name}"
    run "git push git@heroku.com:#{STAGING_APP}.git #{tag_name}^{}:master"
  end

  desc "Promote the last staged build to production."
  task :promote do
    releases = `git tag`.split("\n").select { |t| t[0..6] == 'staged-' }.sort
    staged_release = releases.last
    if staged_release
      run "git push git@heroku.com:#{PRODUCTION_APP}.git #{staged_release}^{}:master"
    else
      puts "No staged release tags found"
    end
  end

end
