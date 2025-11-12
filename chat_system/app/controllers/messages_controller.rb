class MessagesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        chat = Chat.find_by(number: params[:number])
        if chat.nil?
            render json: { error: "Chat not found" }, status: :not_found
            return
        end

        if chat.application.token != params[:token]
            render json: { error: "Invalid token" }, status: :unauthorized
            return
        end

        content = params[:content]
        if content.present?
            # Use Elasticsearch search
            @messages = Message.search(
                query: {
                    bool: {
                        must: [
                        { match: { body: content } },
                        { term: { chat_id: chat.id } }
                        ]
                    }
                }
            ).records
        else
            @messages = chat.messages
        end
     
       render json: @messages
    end

    def create
        chat = Chat.find_by(number: params[:number])
        if chat.nil?
            render json: { error: "Chat not found" }, status: :not_found
            return
        end

        if chat.application.token != params[:token]
            render json: { error: "Invalid token" }, status: :unauthorized
            return
        end


        message_counter_key =  "message_count_chat_#{chat.id}"
        message_number =  $redis.incr(message_counter_key)
  
        # Insert the message.
        message = Message.new(
            chat_id: chat.id,
            number:message_number,
            body: params[:body]
        )
        if message.save
               render json: {
                message: "Message Created",
                data: ActiveModelSerializers::SerializableResource.new(message)
            }, status: :created
        else
            render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
        end
    end

  private

  def message_params
    params.require(:message).permit(:body)
  end

end
