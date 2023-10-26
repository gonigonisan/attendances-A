class CreateBasePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :base_points do |t|
      t.string :base_name
      t.text :information

      t.timestamps
    end
  end
end
