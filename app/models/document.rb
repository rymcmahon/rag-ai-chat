require "net/http"
require "json"

class Document < ApplicationRecord
  has_one_attached :file

  def self.search_similar(query)
    query_embedding = generate_query_embedding(query)
    Document.order(Arel.sql("embedding <-> '#{query_embedding.to_json}'")).limit(5)
  end

  def self.generate_query_embedding(query)
    uri = URI("http://localhost:11434/api/embed")
    response = Net::HTTP.post(uri, { model: "nomic-embed-text", input: query }.to_json, { "Content-Type" => "application/json" })
    JSON.parse(response.body)["embeddings"].flatten.take(384) # Ensure the correct size
  end
end
