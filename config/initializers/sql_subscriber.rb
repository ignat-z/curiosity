class InsertQueriesSubscriber
  attr_reader :events

  def initialize
    @events = []
    @transaction = false
  end

  def call(_, _, _, _, values)
    if values[:sql] =~ /begin transaction/
      @transaction = true
    end

    if @transaction && values[:sql] =~ /INSERT/
      @events << values[:sql]
    end

    if values[:sql] =~ /commit transaction/
      @transaction = false
      puts "*" * 80
      puts @events.map { |sql| sql.match(/INTO \"(.+)\" /)[1] }
      puts "*" * 80
    end
  end
end

insert_subscriber = InsertQueriesSubscriber.new
ActiveSupport::Notifications.subscribe("sql.active_record", insert_subscriber)
