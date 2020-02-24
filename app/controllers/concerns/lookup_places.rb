module LookupPlaces
  extend ActiveSupport::Concern

  included do
    before_action :verify_coordinates_presence, only: [:index]
  end

  def lookup_places(types)
    PlacesLookupService.call(
      lookup_client: GooglePlaces::Client.new(ENV['GOOGLE_API_KEY']),
      lat: params[:lat],
      lng: params[:lng],
      types: types
    ) do
      create_transaction(success: true, error: nil)
    end
  end

  def create_transaction(success: nil, error: nil)
    current_user.transactions.create(
      data: {
        lat: params[:lat],
        lng: params[:lng],
        success: success,
        error: error
      }
    )
  end

  def verify_coordinates_presence
    if params[:lat].blank? || params[:lng].blank?
      message = I18n.t('restaurants.coordinates.required')
      create_transaction(success: false, error: message)
      render json: { message: message }, status: :bad_request
    end
  end

  def handle_lookup_client_error
    message = I18n.t('lookup_client.error_message')
    create_transaction(success: false, error: message)
    render json: { message: message }, status: :ok
  end
end