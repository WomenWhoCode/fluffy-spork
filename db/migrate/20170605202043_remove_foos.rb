class RemoveFoos < ActiveRecord::Migration[5.1]
  def change
    drop_table :foos
  end
end
