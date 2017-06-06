class CreateWatermarks < ActiveRecord::Migration[5.1]
  def change
    create_table :watermarks do |t|
      t.string :url
      t.string :etag

      t.timestamps null: false
    end
  end
end
