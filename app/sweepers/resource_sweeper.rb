class ResourceSweeper < ActionController::Caching::Sweeper
  observe Resource

  def after_save(resource)
    clear_resource_cache(resource)
  end

  def after_destroy(record)
    clear_resource_cache(resource)
  end

  def clear_resource_cache(resource)
    ['top_resources', 'newest_resources', 'featured_resources'].each do |fragment|
      expire_fragment "#{fragment}_html"
      expire_fragment "#{fragment}_fbml"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      expire_fragment "resources_list_#{page}html"
      expire_fragment "resources_list_#{page}fbml"
    end
  end

  def self.expire_resource_all resource
    controller = ActionController::Base.new
    ['top_resources', 'newest_resources', 'featured_resources'].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
      controller.expire_fragment "#{fragment}_fbml"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      controller.expire_fragment "resources_list_#{page}html"
      controller.expire_fragment "resources_list_#{page}fbml"
    end
  end

end
