class SimilarsCollector
  def initialize
  end

  def perform
    previous_ids = []
    results = []
    Person.not_deleted.find_each(batch_size: 25) do |person|
      puts "Working with ID #{person.id}"
      %i(name email phone skype github linkedin).each do |prop|
        next if person.send(prop).to_s.downcase.strip.blank?

        similar_ids = Person.not_deleted
                        .where('id NOT IN (?)', [person.id] + previous_ids)
                        .where("(#{prop.to_s} IS NOT NULL AND #{prop.to_s} != '' AND lower(#{prop.to_s}) LIKE ?)", "%#{person.send(prop).to_s.downcase.strip}%")
                        .pluck(:id)
        if similar_ids.size > 0
          results << {
            person: person.id,
            "similar_#{prop}".to_sym => similar_ids
          }
          previous_ids += (similar_ids + [person.id])
        end
      end
    end
    results
  end
end
