class PlacesLookupService
  def self.call(lookup_client:, lat:, lng:, types:)
    lookup_client.spots(lat, lng, types)
  end
end