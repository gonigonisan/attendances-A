class CreateApplies < ActiveRecord::Migration[5.1]
  def change
    create_table :applies do |t|

      t.timestamps
    end
  end
end
