class ChatsController < ApplicationController
  def index
  end

  def ask
    query = params[:query]
    answer = AgentService.answer_question(query)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append(
          "chat-messages",
          partial: "chats/answer",
          locals: { answer: answer }
        )
      end
      format.html { redirect_to root_path }
    end
  end
end
