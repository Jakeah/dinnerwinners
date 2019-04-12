require 'active_support/concern'

module StringFilter
  extend ActiveSupport::Concern

  # included do
  #   scope :disabled, -> { where(disabled: true) }
  # end

  class_methods do
    #...
  end

  def strip_input_fields

    self.attributes.each do |key, value|
      self[key] = value.strip if value.respond_to?("strip")
    end
  end
end