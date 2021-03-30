module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorize, only: %i[signedin]

      def signup
        @user = User.create(user_params)

        if @user.valid?
          token = encode_token({ user_id: @user.id })
          render json: { user: @user, token: token }
        else
          render json: "\"Invalid Credentials\"" , status: :unauthorized
        end
      end

      def signin
        byebug
        @user = User.find_by(email: user_params[:email])

        if @user && @user.authenticate(user_params[:password])
          token = encode_token({ user_id: @user.id })
          render json: { user: @user, token: token }
        else
          render json: "\"Invalid Credentials\"" , status: :unauthorized
        end
      end

      def signedin
        render json: @user
      end

      private
        def user_params
          params.require(:user).permit(:email, :password)
        end
    end
  end
end
