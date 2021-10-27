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

require 'rails_helper'

RSpec.describe Job, type: :model do
  subject(:job) { create :job }

  it { is_expected.to validate_presence_of(:start_time) }
  it { is_expected.to validate_presence_of(:end_time) }

  describe '#valid_times' do
    it 'ensures that start_time < end_time' do
      invalid = build(:job, start_time: 1.hour.from_now, end_time: Time.current)

      expect(invalid).not_to be_valid
    end
  end
end
