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

class JobSerializer < BaseSerializer
  ATTRS = %w[
    id
    start_time
    end_time
    done
  ].freeze

  def serializable_hash(*)
    attributes.slice(*ATTRS).tap do |attrs|
      attrs[:client] = serialized_client
      attrs[:plumbers] = serialized_pumbers
    end
  end

  private

  def serialized_client
    ClientSerializer.new(client, address: true)
  end

  def serialized_pumbers
    PlumberSerializer.map(plumbers)
  end
end
