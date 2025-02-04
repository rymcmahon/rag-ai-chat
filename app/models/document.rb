require "net/http"
require "json"

class Document < ApplicationRecord
  has_one_attached :file

  after_commit :generate_embedding, on: :create

  def self.search_similar(query)
    query_embedding = generate_embedding(query)  # Call the embedding function for the query

    find_by_sql([ <<-SQL, query_embedding ])
      SELECT *, embedding <-> ? AS distance
      FROM documents
      ORDER BY distance
      LIMIT 5;
    SQL
  end


  private

  def generate_embedding
    return unless text_content.present?

    uri = URI("http://localhost:11434/api/generate")
    response = Net::HTTP.post(uri, { model: "nomic-embed-text", prompt: text_content }.to_json, { "Content-Type" => "application/json" })
    embedding = JSON.parse(response.body)["embedding"]

    update(embedding: embedding)
  end
end
