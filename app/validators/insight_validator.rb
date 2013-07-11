class InsightValidator < ActiveModel::Validator
  def validate(record)
    record.interests.each do |interest|
      interest.insights.each do |insight|
        record.errors.add( :base, insight.errors.full_messages) unless insight.valid?
      end
    end
  end
end
