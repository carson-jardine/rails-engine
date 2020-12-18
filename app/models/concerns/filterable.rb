module Filterable
  extend ActiveSupport::Concern

  class_methods do
    def filter_from_params(filtering_params)
      results = self.where(nil)
      filtering_params.each do |attribute, value|
        results = results.public_send("filter_by_#{attribute}", value) if value.present?
      end
      results
    end
  end
end
