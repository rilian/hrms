module VacanciesHelper
  def vacancy_candidates_by_status(vacancy)
    result = {}
    PERSON_STATUS_COLORS.keys.each do |status|
      count = Person
                .not_deleted
                .where(status: status)
                .tagged_with(vacancy.tag, any: true)
                .count
      result[status] = count if count > 0
    end
    result
  end
end
