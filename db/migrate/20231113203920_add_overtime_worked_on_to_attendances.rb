class AddOvertimeWorkedOnToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_worked_on, :datetime
  end
end
