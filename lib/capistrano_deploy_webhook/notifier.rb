require 'net/http'
require 'uri'

unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano_deploy_webhook requires Capistrano 2"
end

Capistrano::Configuration.instance.load do
  after :deploy, "notify:post_request"

  namespace :notify do
    task :post_request do
      application_name = `pwd`.chomp.split('/').last
      puts "*** Notification POST to #{self[:notify_url]}"
      url = URI.parse("#{self[:notify_url]}")
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data(
        {'app_name' => application_name, 
         'app' => application_name, 
         'user' => self[:user], 
         'sha' => self[:current_revision], 
         'prev_sha' => self[:previous_revision], 
         'url' => self[:url]}, 
         ';')
      res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
    end
  end
end


