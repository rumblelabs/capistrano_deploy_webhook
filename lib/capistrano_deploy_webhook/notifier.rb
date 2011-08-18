require 'net/http'
require 'uri'

unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano_deploy_webhook requires Capistrano 2"
end

GIT_USER_EMAIL = `git config --get user.email`
GIT_CURRENT_REV = `git rev-parse HEAD`
GIT_CURRENT_REV_SHORT = git_current_rev[0,7]

Capistrano::Configuration.instance.load do
  after :deploy, "notify:post_request"

  namespace :notify do
    task :post_request do
      application_name = `pwd`.chomp.split('/').last

      puts "*** Notification POST to #{self[:notify_url]} for #{application_name}"
      url = URI.parse("#{self[:notify_url]}")
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data(
        {'app' => application_name, 
         'user' => GIT_USER_EMAIL, 
         'head' => GIT_CURRENT_REV_SHORT, 
         'head_long' => GIT_CURRENT_REV,
         'prev_head' => self[:previous_revision], 
         'url' => self[:url]}, 
         ';')
      res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
    end
  end
end


