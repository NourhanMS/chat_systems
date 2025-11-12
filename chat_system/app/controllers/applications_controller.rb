class ApplicationsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        applications = Application.all
        render json: applications
    end

    def create
        # generates a 32-character hex token.
        token = SecureRandom.hex(16) 
        application = Application.new(application_params.merge(token: token))
        if application.save
               render json: {
                message: "Application Created",
                data: ActiveModelSerializers::SerializableResource.new(application)
            }, status: :created
        else
            render json: { errors: application.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update_by_token
        application = Application.find_by(token: params[:token])

        if application.nil?
            render json: { error: "Application not found" }, status: :unauthorized
        elsif application.update(name: application_params[:name])
          render json: {
                message: "Application name updated",
                data: ActiveModelSerializers::SerializableResource.new(application)
            }, status: :ok
        else
            render json: { errors: application.errors.full_messages }, status: :unprocessable_entity
        end
    end

  private

  def application_params
    params.require(:application).permit(:name)
  end
end
