class PlacesLookupService

  # NOTE: Ideally the result should be cached.
  # That way we don't make unessesary API calls.
  #
  # NOTE: Ideally yhis class should accept any lookup client.
  # That way we can switch beteen clients without touching this class.
  # The adapter design pattern should work to achive that behaivour.
  def self.call(lookup_client:, lat:, lng:, types:)
    lookup_client.spots(lat, lng, types)
  end
end