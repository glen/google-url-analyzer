module DbHelper
  ##
  # Opens the db connection
  #
  def create_connection
    Rufus::Tokyo::Cabinet.new("#{CONFIG['db_location']}/#{CONFIG['db_database']}")
  end

  ##
  # Close the db connection
  #
  def close_connection(db_connection)
    db_connection.close
  end
end
