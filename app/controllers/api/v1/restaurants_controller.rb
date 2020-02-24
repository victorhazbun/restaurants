# frozen_string_literal: true

module Api
  module V1
    class RestaurantsController < ApplicationController
      include LookupPlaces

      LOOKUP_TYPE = 'restaurant'

      rescue_from StandardError, with: :handle_lookup_client_error

      def index
        restaurants = lookup_places(LOOKUP_TYPE)
        render json: { data: restaurants.to_json }, status: :ok
      end
    end
  end
end