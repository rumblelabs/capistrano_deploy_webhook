# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "capistrano_deploy_webhook"
  s.summary = "Post to a specified url after deployment"
  s.description = "Post to a specified url after deployment"
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.mdown"]
  s.test_files = Dir["test/**/*"]
  s.version = "0.0.1"
end
