module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_user

      def create
        user = User.new(user_params)
        if user.save
          render json: user, status: :created
        else
          render json: user.errors.full_messages.to_json, status: :bad_request
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password)
      end
    end
  end
end