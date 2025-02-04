require "pdf-reader"

class DocumentsController < ApplicationController
  def create
    document = Document.new(filename: params[:file].original_filename)
    document.file.attach(params[:file])

    if document.save
      extract_text(document)
      generate_embedding(document)
      render json: { message: "File uploaded and processed", document_id: document.id }, status: :created
    else
      render json: { error: document.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
  end

  def search
    query = params[:query]
    results = Document.search_similar(query)
    render json: results
  end

  private

  def extract_text(document)
    file_path = ActiveStorage::Blob.service.send(:path_for, document.file.key)
    reader = PDF::Reader.new(file_path)
    text = reader.pages.map(&:text).join("\n")
    document.update(text_content: text)
  end

  def generate_embedding(document)
    uri = URI("http://localhost:11434/api/embed")
    response = Net::HTTP.post(uri, { model: "nomic-embed-text", input: document.  text_content }.to_json, { "Content-Type" => "application/json" })

    embeddings = JSON.parse(response.body)["embeddings"]

     flattened = embeddings.flatten
     truncated = flattened.take(384)
     document.update(embedding: truncated)
  end
end
