# frozen_string_literal: true

class MakeFullNameNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :full_name, false
  end
end
