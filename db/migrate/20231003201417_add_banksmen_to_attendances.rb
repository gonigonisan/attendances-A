class AddBanksmenToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :banksmen, :string
  end
end
