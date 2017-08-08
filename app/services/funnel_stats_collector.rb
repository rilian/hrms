class FunnelStatsCollector
  NO_STATUS_STATUSES = ['n/a', 'Pinged, no response']
  NOT_INTERESTED_STATUSES = ['Not interested', 'Not interested, on hold', 'Rejected, no go', 'Rejected, on hold']
  INTERESTED_STATUSES = ['Discussing an opportunity', 'Interested, ping later', 'Interested, on hold']
  INTERVIEW_STATUSES = ['Initial interview', 'Technical interview', 'Test assignment']
  PASSED_INTERVIEW_STATUSES = ['Waiting for decision']
  HIRED_STATUSES = ['Hired', 'Contractor', 'Past employee', 'Past contractor']

  def initialize(scope:, start_date:, finish_date:)
    @scope = scope
    @start_date = start_date
    @finish_date = finish_date
  end

  def perform
    result = []

    Vacancy.where(status: 'open').each do |vacancy|
      people_created = @scope.tagged_with([vacancy.tag].flatten)
          .where('people.created_at >= ? AND people.created_at <= ?',
            Time.strptime(@start_date, '%d-%m-%Y').strftime('%Y-%m-%d') + ' 00:00:00',
            Time.strptime(@finish_date, '%d-%m-%Y').strftime('%Y-%m-%d') + ' 00:00:00')
      people = @scope.tagged_with([vacancy.tag].flatten)
          .where('people.updated_at >= ? AND people.updated_at <= ?',
            Time.strptime(@start_date, '%d-%m-%Y').strftime('%Y-%m-%d') + ' 00:00:00',
            Time.strptime(@finish_date, '%d-%m-%Y').strftime('%Y-%m-%d') + ' 00:00:00')

      item = {
        vacancy_title: "#{vacancy.project}, #{vacancy.role}",
        vacancy_id: vacancy.id,
        vacancy_tag: vacancy.tag,
        people_created: people_created.count,
        people_updated_count: people.count,
        people_no_status_count: people.where(status: NO_STATUS_STATUSES).count,
        people_not_interested_count: people.where(status: NOT_INTERESTED_STATUSES).count,
        people_interested_count: people.where(status: INTERESTED_STATUSES).count,
        people_interview_count: people.where(status: INTERVIEW_STATUSES).count,
        people_passed_interview_count: people.where(status: PASSED_INTERVIEW_STATUSES).count,
        people_hired_count: people.where(status: HIRED_STATUSES).count
      }

      sources = {}
      people.pluck(:source).uniq.each do |source|
        sources[source.presence || 'n/a'] = people.where(source: source).count
      end
      item[:sources] = sources.sort { |a,b| b[1] <=> a[1] }.to_h

      updates = []
      people.pluck(:updated_by_id).uniq.each do |by_id|
        updates << {
          by_id: by_id,
          name: User.find(by_id).email.split('@').first,
          count: people.where(updated_by_id: by_id).count
        }
      end
      item[:updates] = updates.sort { |a,b| puts a; b[:count] <=> a[:count] }

      result << item
    end

    result.sort { |a, b| b[:people_updated_count] <=> a[:people_updated_count] }
  end
end
