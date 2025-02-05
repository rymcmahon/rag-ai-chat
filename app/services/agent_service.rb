class AgentService
  def self.answer_question(query)
    documents = Document.search_similar(query)
    context = documents.map(&:text_content).join("\n\n")

    uri = URI("http://localhost:11434/api/generate")
    body = {
      model: "mistral",
      prompt: "Using the following context, answer the question:\n\n#{context}\n\nQuestion: #{query}",
      stream: false
    }.to_json

    response = Net::HTTP.post(uri, body, { "Content-Type" => "application/json" })
    JSON.parse(response.body)["response"]
  end
end
