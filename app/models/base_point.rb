class BasePoint < ApplicationRecord
  validates :base_number, length: { in: 2..30 }, allow_blank: true
  validates :base_name, length: { in: 2..30 }, allow_blank: true
  validates :information, length: { in: 2..30 }, allow_blank: true
end
