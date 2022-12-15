class ChangeEmailColumn < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :email, :string, default: "", null: true
  end
end
