class HistoricalDataCollector
  def initialize
    @data = {}
  end

  def perform
    [ActionPoint, Attachment, Dayoff, Event, Note, Person, User, Vacancy].each do |klass|
      table = klass.table_name
      @data[table] = {}
      date_today = Time.zone.now.strftime('%Y-%m-%d')
      date_oldest = klass.first.created_at.strftime('%Y-%m-%d')

      query = "SELECT
        count(#{table}.id) AS cnt,
        to_char(d.day, 'YYYY-MM-DD') AS day
      FROM
        generate_series('#{date_oldest}'::date, '#{date_today}'::date, '1d') AS d(day)
        LEFT OUTER JOIN #{table} ON #{table}.created_at >= d.day
          AND #{table}.created_at < d.day + '1d'::interval
      GROUP BY d.day
      ORDER BY d.day"

      @data[table] = ActiveRecord::Base.connection.execute(query).to_a
    end
    @data
  end
end
