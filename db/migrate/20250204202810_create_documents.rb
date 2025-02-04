class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string :filename
      t.text :text_content

      t.timestamps
    end
  end
end
