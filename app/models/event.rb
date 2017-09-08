class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :entity, polymorphic: true

  validates :entity, :entity_type, :entity_id, :action, presence: true

  def self.log(entity:, action:, user: nil, params: {})
    create(
      entity: entity,
      action: "#{entity.class.name.underscore}.#{action}",
      params: params,
      user: user
    )
  end
  
  private

  ransacker :params_as_str do
    Arel.sql("#{arel_table.name}.params::varchar")
  end
end
