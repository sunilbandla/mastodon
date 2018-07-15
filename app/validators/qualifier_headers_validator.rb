# frozen_string_literal: true

class QualifierHeadersValidator < ActiveModel::Validator
  include JsonLdHelper

  def validate(qualifier)
    return unless qualifier.headers?

    qualifier.headers.strip!
    json = body_to_json(qualifier.headers)

    qualifier.errors.add(:headers, I18n.t('qualifiers.yours.invalid_headers')) unless !json.nil?
  end

  private

end
