CONFIG = DaemonKit::Config.load('config.yml')

require 'eventmachine'
require 'rufus/tokyo'
require 'md5'

# Require helper files
Dir.glob(File.join("#{DAEMON_ROOT}", "helpers", "*.rb")).each{|f| require f }
include DbHelper

$DB = DbHelper.create_connection
