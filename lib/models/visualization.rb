require 'chronic'
require 'chronic_duration'

class Visualization < ActiveRecord::Base
  belongs_to :user
  has_one :profile, through: :user

  has_one :site, through: :page
  has_one :site_visited, through: :site

  belongs_to :video

  belongs_to :page
  delegate :url, to: :page

  validates :session_id, presence: true, length: { is: 36 }

  scope :by_dates, -> (dates_begin, dates_end) {
    intervals = dates_begin.zip(dates_end).flatten
    where((['(date_started >= ? AND (date_ended <= ? OR date_ended IS NULL))'] * dates_begin.size).join(' OR '), *intervals)
  }

  scope :by_usernames, -> (usernames) { where(user: User.where(username: usernames)) }

  scope :summary, lambda {
    select('videos.title',
           'videos.url',
           'videos.publisher',
           'videos.video_length',
           'users.username as username',
           'sum(time_viewed) as time_viewed',
           'min(visualizations.date_started) as date_started')
        .joins(:user, :video)
        .group('videos.title',
               'videos.url',
               'videos.publisher',
               'videos.video_length',
               'users.username')
        .order('videos.url')
  }

  def update_stats(captured_at, state)
    case state
    when 'playing' then on_playing(captured_at)
    when 'ended' then on_ended(captured_at)
    when 'pause' then on_pause(captured_at)
    end

    save!
  end

  private

  def on_ended(datetime)
    self.date_ended = datetime

    on_pause(datetime)
  end

  def on_playing(datetime)
    self.date_started, self.date_fragment_started = datetime, datetime
  end

  def on_pause(datetime)
    return unless date_fragment_started

    self.time_viewed += (datetime - date_fragment_started).to_i
    self.date_fragment_started = nil
  end
end
