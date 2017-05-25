class CreatesFoos < ActiveRecord::Migration[5.1]
  def change
    create_table :foos do |t|
      t.string :name
      t.boolean :published, default: false
    end
  end
end
