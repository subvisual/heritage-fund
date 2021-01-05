class ProjectValidator < ActiveModel::Validator
  def validate(record)
    if !Date.valid_date? record.start_date_year.to_i, record.start_date_month.to_i, record.start_date_day.to_i
      record.errors.add(
        :start_date,
        I18n.t("activerecord.errors.models.project.attributes.start_date.invalid")
      )
    else
      unless Date.new(record.start_date_year.to_i, record.start_date_month.to_i, record.start_date_day.to_i) > Date.today
        record.errors.add(
          :start_date,
          I18n.t("activerecord.errors.models.project.attributes.start_date.in_past")
        )
      end
    end

    if !Date.valid_date? record.end_date_year.to_i, record.end_date_month.to_i, record.end_date_day.to_i
      record.errors.add(
        :end_date,
        I18n.t("activerecord.errors.models.project.attributes.end_date.invalid")
      )
    else
      unless Date.new(record.end_date_year.to_i, record.end_date_month.to_i, record.end_date_day.to_i) > Date.today
        record.errors.add(
          :end_date,
          I18n.t("activerecord.errors.models.project.attributes.end_date.in_past")
        )
      end
    end

    unless record.errors.key?(:start_date) || record.errors.key?(:end_date)
      unless Date.new(record.end_date_year.to_i, record.end_date_month.to_i, record.end_date_day.to_i) >
          Date.new(record.start_date_year.to_i, record.start_date_month.to_i, record.start_date_day.to_i)
        record.errors.add(
          :start_date,
          I18n.t("activerecord.errors.models.project.attributes.start_date.after_end_date")
        )
        record.errors.add(
          :end_date,
          I18n.t("activerecord.errors.models.project.attributes.end_date.before_start_date")
        )
      end
    end
  end
end
