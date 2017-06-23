class AddGroupUrlnameToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :group_urlname, :string
  end
end
