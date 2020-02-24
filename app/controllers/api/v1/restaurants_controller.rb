# frozen_string_literal: true

module Api
  module V1
    class RestaurantsController < ApplicationController
      before_action :verify_coordinates_presence

      rescue_from StandardError, with: :handle_lookup_client_error

      def index
        restaurants = PlacesLookupService.call(
          lookup_client: GooglePlaces::Client.new(ENV['GOOGLE_API_KEY']),
          lat: params[:lat],
          lng: params[:lng],
          types: 'restaurants'
        )
        render json: restaurants.to_json, status: :ok
      end

      private

      def verify_coordinates_presence
        if params[:lat].blank? || params[:lng].blank?
          render json: { message: I18n.t('restaurants.coordinates.required') }, status: :bad_request
        end
      end

      def handle_lookup_client_error
        render json: { message: I18n.t('lookup_client.error_message') }, status: :ok
      end
    end
  end
end