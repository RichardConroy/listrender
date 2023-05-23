# frozen_string_literal: true

class CreateS3Downloads < ActiveRecord::Migration[7.0]
  def change
    create_table :s3_downloads do |t|
      t.jsonb :manifest

      t.timestamps
    end
  end
end
