# frozen_string_literal: true

class PlacesLookupService
  # NOTE: Ideally This class should accept any lookup client.
  # That way we can switch beteen clients without touching this class.
  # The adapter design pattern should work to achive that behaivour.
  # NOTE: We are not catching specific failures, like OVER_QUERY_LIMIT.
  # Each exception should have it's own handling mechanism, but for now we trait them all equal.
  def self.call(lookup_client:, lat:, lng:, types:, &callback)
    result = Rails.cache.fetch("lat-#{lat}-lng-#{lng}-types-#{types}", expires_in: 24.hours) do
      lookup_client.spots(lat, lng, types: types)
    end
    callback.call
    result
  end
end