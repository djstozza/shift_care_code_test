# == Schema Information
#
# Table name: jobs
#
#  id         :bigint           not null, primary key
#  done       :boolean          default(FALSE), not null
#  end_time   :datetime         not null
#  start_time :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint
#
# Indexes
#
#  index_jobs_on_client_id  (client_id)
#

class Job < ApplicationRecord
  has_paper_trail

  belongs_to :client
  has_and_belongs_to_many :plumbers

  validates :start_time, :end_time, presence: true
  validate :valid_times

  private

  def valid_times
    return unless start_time.present? && end_time.present?
    return if start_time < end_time

    errors.add(:start_time, 'must be earlier than end time')
  end
end
