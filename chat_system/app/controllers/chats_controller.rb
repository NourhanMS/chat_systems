class ChatsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
       application = Application.find_by(token: params[:token])
        if application.nil?
            render json: { error: "Application not found" }, status: :unauthorized
            return
        end
       render json: application.chats
    end

    def create
        # Find the application by token.
        application = Application.find_by(token: params[:token])
        if application.nil?
            render json: { error: "Application not found" }, status: :unauthorized
            return
        end

        chat_counter_key =  "chat_count_app_#{application.id}"
        chat_number =  $redis.incr(chat_counter_key)
  
        # Insert the chat.
        chat = Chat.new(
            application_id: application.id,
            number:chat_number
        )
        if chat.save
               render json: {
                message: "Chat Created",
                data: ActiveModelSerializers::SerializableResource.new(chat)
            }, status: :created
        else
            render json: { errors: chat.errors.full_messages }, status: :unprocessable_entity
        end
    end
end
