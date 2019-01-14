class PerformanceReviewStatsCollector
  attr_accessor :start_date, :finish_date, :scope
  def initialize(scope:, start_date:, finish_date:, order:)
    @scope = scope
    @start_date = start_date
    @finish_date = finish_date
    @order = order
  end

  def perform
    if Time.strptime(@start_date, '%d-%m-%Y') > Time.strptime(@finish_date, '%d-%m-%Y')
      @start_date, @finish_date = @finish_date, @start_date
    end

    @scope = Person
      .not_deleted
      .current_employee
      .where(skip_reviews: false)
      .where('finish_date IS NULL OR finish_date > ?', Time.zone.now.strftime('%F'))
      .where('next_performance_review_at IS NULL OR next_performance_review_at >= ? AND next_performance_review_at <= ?',
             Time.strptime(@start_date, '%d-%m-%Y').strftime('%Y-%m-%d') + ' 00:00:00',
             Time.strptime(@finish_date, '%d-%m-%Y').strftime('%Y-%m-%d') + ' 00:00:00')

    case @order.presence
      when 'last_review'
        @scope = @scope.reorder('next_performance_review_at IS NOT NULL, last_performance_review_at IS NOT NULL, last_performance_review_at ASC')
      else 'next_review'
        @scope = @scope.reorder('next_performance_review_at IS NOT NULL, last_performance_review_at IS NOT NULL, next_performance_review_at ASC')
    end

    @scope = @scope.order(:name)
  end
end
