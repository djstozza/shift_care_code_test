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

FactoryBot.define do
  factory :job do
    start_time { Time.current.beginning_of_hour }
    end_time { 2.hours.from_now.beginning_of_hour }

    association :client

    trait :done do
      done { true }
    end
  end
end
