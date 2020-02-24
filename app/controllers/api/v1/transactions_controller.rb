# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < ApplicationController
      after_action { pagy_headers_merge(@pagy) if @pagy }

      def index
        @pagy, @transactions = pagy(current_user.transactions)

        if stale?(@transactions)
          render json: { data: @transactions }, status: :ok
        end
      end
    end
  end
end