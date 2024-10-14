require 'bundler/inline'

gemfile(true) do
  source 'https://rubygems.org'
  gem 'sql_formatter'
end

require 'benchmark'
require 'sql_formatter'

module LocalUtils
  def self.measure(&block)
    # Measure the execution time of the block or lambda
    result = Benchmark.measure do
      block.call
    end
    puts "Execution time: #{result.real} seconds"
    result
  end

  def self.explain(&block)
    # Store the subscription so we can later unsubscribe
    subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |_, _, _, _, details|
      sql = details[:sql]
      next if sql =~ /SHOW FULL FIELDS|SHOW CREATE TABLE|EXPLAIN/

      # Prepend EXPLAIN to the SQL query
      explain_sql = "EXPLAIN ANALYZE #{sql}"

      # Execute the EXPLAIN query
      begin
        result = ActiveRecord::Base.connection.execute(explain_sql)

        # Format the EXPLAIN result (based on your database, e.g., PostgreSQL, MySQL)
        formatted_explain = format_explain_result(result)

        puts "\nEXPLAIN Output:\n#{formatted_explain}"
      rescue => e
        puts "Error running EXPLAIN: #{e.message}"
      end
    end

    # Execute the lambda/query
    block.call

    # Unsubscribe from the SQL event after running the query
    ActiveSupport::Notifications.unsubscribe(subscriber)
  end

  @pretty_print_active = false
  @pp_subscription = nil

  # Method to toggle pretty print SQL on and off
  def self.pretty_print_sql
    if @pretty_print_active
      # Unsubscribe if already active
      ActiveSupport::Notifications.unsubscribe(@subscription)
      @pretty_print_active = false
      puts "Pretty print SQL is now OFF."
    else
      # Subscribe if not active
      @pp_subscription = ActiveSupport::Notifications.subscribe("sql.active_record") do |_, _, _, _, details|
        sql = details[:sql]
        next if sql =~ /SHOW FULL FIELDS|SHOW CREATE TABLE/

        formatted_sql = format_and_colorize_sql(sql)
        puts formatted_sql
      end
      @pretty_print_active = true
      puts "Pretty print SQL is now ON."
    end
  end

  private

  def format_explain_result(result)
    result.map do |row|
      row.join(" | ")
    end.join("\n")
  end

  def format_and_colorize_sql(sql)
    formatted_sql = SqlFormatter.format(sql)

    # Add line breaks before common SQL keywords
    formatted_sql = formatted_sql.gsub(/(SELECT|FROM|WHERE|ORDER BY|GROUP BY|LIMIT|INSERT INTO|VALUES)/i, "\n\\1")

    # Colorize SQL keywords
    keywords = %w[SELECT FROM WHERE ORDER BY GROUP BY LIMIT INSERT INTO VALUES]
    keywords.each do |keyword|
      formatted_sql.gsub!(/\b#{keyword}\b/i, keyword.colorize(:light_blue).bold)
    end

    formatted_sql
  end
end
