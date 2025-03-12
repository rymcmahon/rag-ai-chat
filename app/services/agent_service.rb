class AgentService
  def self.answer_question(query)
    documents = Document.search_similar(query)
    context = documents.map(&:text_content).join("\n\n")

    uri = URI("http://localhost:11434/api/generate")
    body = {
      model: "nous-hermes2",
      system: "You are a customer service agent for the Chip and Charge Tennis Gear company. All of your responses should be from the provided context.",
      prompt: "Context:\n\n#{context}\n\nQuestion: #{query}",
      temperature: 0.2, # Lower temp for more deterministic responses
      stream: false
    }.to_json

    response = Net::HTTP.post(uri, body, { "Content-Type" => "application/json" })
    JSON.parse(response.body)["response"]
  end
end
