class AnnouncementSweeper < ActionController::Caching::Sweeper
  observe Announcement

  def after_save(announcement)
    ['newest_announcements'].each do |fragment|
      expire_fragment "#{fragment}_html"
      expire_fragment "#{fragment}_fbml"
    end
  end

  def after_destroy(announcement)
    ['newest_announcements'].each do |fragment|
      expire_fragment "#{fragment}_html"
      expire_fragment "#{fragment}_fbml"
    end
  end

  def self.expire_announcement_all
    controller = ActionController::Base.new
    ['newest_announcements'].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
      controller.expire_fragment "#{fragment}_fbml"
    end
  end

end
