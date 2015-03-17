class RawMessageLog < ActiveRecord::Base
  belongs_to :raw_message

  module Actions
    FROM_REDIS = 'from_redis'
    TO_PAGE_VISITS = 'to_page_visits'
    TO_VIDEO_VISITS = 'to_video_visits'
  end

  def self.new_from_redis
    self.new(:action => Actions::FROM_REDIS)
  end
  def self.new_to_page_visits
    self.new(:action => Actions::TO_PAGE_VISITS)
  end
  def self.new_to_video_visits
    self.new(:action => Actions::TO_VIDEO_VISITS)
  end
end


