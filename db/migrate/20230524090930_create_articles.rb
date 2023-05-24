# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.integer :external_id
      t.string :title
      t.string :description
      t.references :s3_download, null: false, foreign_key: true

      t.timestamps
    end
  end
end
