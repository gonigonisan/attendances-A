class AddBaseNumberToBasePoints < ActiveRecord::Migration[5.1]
  def change
    add_column :base_points, :base_number, :integer
  end
end
