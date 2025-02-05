class PromptsController < ApplicationController
  def index
  end

  def ask
    query = params[:query]
    answer = AgentService.answer_question(query)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("prompt-messages", partial: "prompts/message", locals: { query: query, answer: answer })
      end
      format.html { redirect_to root_path, notice: "Response received" }
    end
  end
end
