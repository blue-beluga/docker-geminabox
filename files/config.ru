# encoding: UTF-8

require 'geminabox'

Geminabox.data = '/data'
Geminabox.build_legacy = false
Geminabox.rubygems_proxy = true
Geminabox.allow_remote_failure = true

# use Rack::Auth::Basic, 'Gem in a Box ' do |username, password|
#   username == ENV['GEMBOX_USER'] && password == ENV['GEMBOX_PASSWORD']
# end

run Geminabox::Server
