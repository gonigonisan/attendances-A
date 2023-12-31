class Apply < ApplicationRecord
    belongs_to :user
    belongs_to :attendance
    validates :user_id, presence: true
    validates :attendance_id, presence: true
    validates  :user_id, uniqueness: { scope: :attendance_id}
    validates  :attendance_id, uniqueness: { scope: :user_id}
end
