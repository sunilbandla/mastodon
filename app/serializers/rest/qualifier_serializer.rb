# frozen_string_literal: true

class REST::QualifierSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :endpoint,
             :qualifier_category_id, :user_id, :price, :version

  def id
    object.id
  end

  def name
    object.name
  end

  def description
    object.description
  end

  def endpoint
    object.endpoint
  end

  def qualifier_category_id
    object.qualifier_category_id
  end

  def user_id
    object.user_id
  end

  def price
    object.price.to_f
  end

  def version
    object.version
  end
end
