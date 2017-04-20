class Event < ApplicationRecord
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
end
