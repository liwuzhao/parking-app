class Parking < ApplicationRecord
  validates_presence_of :parking_type, :start_at
  validates_inclusion_of :parking_type, :in => ["guest", "short-term", "long-term"]

  validate :validate_end_at_with_amount

  #自订了一个检查规则是 end_at 和 amount 需要一起填
  def validate_end_at_with_amount
    if ( end_at.present? && amount.blank?)
      errors.add(:amount, "有结束时间就必须有金额")
    end

    if (end_at.blank? && amount.present?)
      errors.add(:end_at, "有金额就必须有结束时间")
    end
  end

  def duration
    (end_at - start_at) / 60
  end


  def calculate_amount
    if self.amount.blank? && self.start_at.present? && self.end_at.present?
      if duration <= 60
        self.amount = 200
      else
        self.amount = 200 + ((duration - 60).to_f / 30).ceil * 100
      end
    end
  end

end
