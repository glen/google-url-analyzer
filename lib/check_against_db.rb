class CheckAgainstDb
  def self.safe?(url)
    url = url.strip.gsub("\n", "")
    return true if url == "/"
    return true if url.empty?
    self.check_url(url)
  end

  def self.get_urls(u)
    urls = []
    stripped_url = u.strip.sub("http://", "").sub(/:\d*/, '')
    urls << stripped_url
    urls << stripped_url.split('?').first if stripped_url.match(/\?/)
    urls << stripped_url.split('/').first  + "/" if stripped_url.match(/\//)

    ary = []
    ary = stripped_url.split('?').first.split('/')
    ary.pop
    urls << ary.join('/') + "/" unless ary.empty?
    
    a = []
    urls.uniq.each{|url| a << url }
    return a
  end

  def self.check_url(u)
    urls_to_check = []
    u = u.sub(/\/\Z/,"") while  u.match(/\/\Z/) # Removes all trailing slashes; we need to have only one and we add it below
    stripped_url = u.strip.sub("http://", "").sub(/:\d*/, '') + "/" # Removes 'http://' and adds a trailing slash
    urls_to_check << self.get_urls(stripped_url)
    ary = stripped_url.split('/').first.split('.')
    last = stripped_url.split('/').slice(1,10).join('/') if stripped_url.split('/').length > 1
    ary = ary.slice(ary.length-6, 10) if ary.length > 6
    while ary.length > 2
      ary = ary.slice(1,5)
      unless last.nil?
        urls_to_check << self.get_urls(ary.join('.') + "/" + last)
      else
        urls_to_check << self.get_urls(ary.join('.') + "/")
      end
    end

    urls = []
    (urls_to_check.flatten.uniq.compact).each{|u| urls << Digest::MD5.hexdigest(u) } 

    safe = $DB.lget(urls).empty? # Use 'lget' to query for multiple values all at once.

    return safe
  end  
end
