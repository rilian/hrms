class HistoricalDataCollector
  KLASSES = [Person, Note, ActionPoint, Attachment, Vacancy, Dayoff, Event, User, Search]

  def initialize
    @data = {}

    set_oldest_date
    set_today
  end

  def perform
    KLASSES.each do |klass|
      table = klass.table_name

      query = "SELECT
        count(#{table}.id) AS cnt,
        to_char(d.day, 'YYYY-MM-DD') AS day
      FROM
        generate_series('#{@oldest_date}'::date, '#{@today}'::date, '1d') AS d(day)
        LEFT OUTER JOIN #{table} ON #{table}.created_at >= d.day
          AND #{table}.created_at < d.day + '1d'::interval
      GROUP BY d.day
      ORDER BY d.day"

      ActiveRecord::Base.connection.execute(query).to_a.each do |item|
        @data[item['day']] = {} if @data[item['day']].nil?
        @data[item['day']][table] = item['cnt']
      end
    end

    @data
  end

  private

  def set_oldest_date
    date = Time.zone.now
    KLASSES.each do |klass|
      date = klass.first.created_at if date > klass.first.created_at
    end
    @oldest_date = date.strftime('%Y-%m-%d')
  end

  def set_today
    @today = Time.zone.now.strftime('%Y-%m-%d')
  end
end
