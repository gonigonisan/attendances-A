class AddUserToBasePoints < ActiveRecord::Migration[5.1]
  def change
    add_reference :base_points, :user, foreign_key: true
  end
end
