class ProjectValidator < ActiveModel::Validator

  def validate(record)

    if !Date.valid_date? record.start_date_year.to_i, record.start_date_month.to_i, record.start_date_day.to_i
      record.errors.add(:start_date, "Enter a valid project start date")
    else
      unless Date.new(record.start_date_year.to_i, record.start_date_month.to_i, record.start_date_day.to_i) > Date.today
        record.errors.add(:start_date, "Start date cannot be in past")
      end
    end

    if !Date.valid_date? record.end_date_year.to_i, record.end_date_month.to_i, record.end_date_day.to_i
      record.errors.add(:end_date, "Enter a valid project end date")
    else
      unless Date.new(record.end_date_year.to_i, record.end_date_month.to_i, record.end_date_day.to_i) > Date.today
        record.errors.add(:end_date, "End date cannot be in past")
      end
    end

    unless record.errors.key?(:start_date) or record.errors.key?(:end_date)
      unless Date.new(record.end_date_year.to_i, record.end_date_month.to_i, record.end_date_day.to_i) >
          Date.new(record.start_date_year.to_i, record.start_date_month.to_i, record.start_date_day.to_i)
        record.errors.add(:start_date, "Start date cannot be after end date")
        record.errors.add(:end_date, "End date cannot be before start date")
      end
    end

  end

end