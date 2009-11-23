# Your starting point for daemon specific classes. This directory is
# already included in your load path, so no need to specify it.

require "#{DAEMON_ROOT}/lib/check_against_db.rb"
require "#{DAEMON_ROOT}/lib/array.rb"
class Echo < EM::Connection
  def receive_data(data)
    unsafe_urls = []
    if data.match(/quit/)
      EM.stop
    end
    # Split the data up by a "\n"
    # We get a string like "http://www.google.com\nhttp://www.yahoo.com"
    # Take each url and then send it to check against the database
    urls = data.split("\n")
    urls.each do |url|
      unsafe_urls << url unless CheckAgainstDb.safe?(url)
    end
    if unsafe_urls.empty?
      send_data("All Safe")
    else
      DaemonKit.logger.info "Unsafe #{unsafe_urls.join(", ")}" unless unsafe_urls.empty?
      send_data(unsafe_urls.join("\n"))
    end    
  end
end

EM.run do
  EM.start_server(CONFIG['db_host'], CONFIG['listen_to_port'], Echo)
end
