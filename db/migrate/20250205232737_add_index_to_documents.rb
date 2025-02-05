class AddIndexToDocuments < ActiveRecord::Migration[8.0]
  def change
    add_index :documents, :embedding, using: :hnsw, opclass: :vector_l2_ops
  end
end
