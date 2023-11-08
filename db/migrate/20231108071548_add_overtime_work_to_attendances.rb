class AddOvertimeWorkToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_work, :string
  end
end
