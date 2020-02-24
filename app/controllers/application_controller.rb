class ApplicationController < ActionController::API
  include Knock::Authenticable
  include Pagy::Backend

  before_action :authenticate_user
end
