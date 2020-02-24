# frozen_string_literal: true

module Api
  module V1
    class RestaurantsController < ApplicationController
      before_action :verify_coordinates_presence

      rescue_from StandardError, with: :handle_lookup_client_error

      def index
        restaurants = lookup_restaurants
        render json: { data: restaurants.to_json }, status: :ok
      end

      private

      def lookup_restaurants
        PlacesLookupService.call(
          lookup_client: GooglePlaces::Client.new(ENV['GOOGLE_API_KEY']),
          lat: params[:lat],
          lng: params[:lng],
          types: 'restaurants'
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
  end
end