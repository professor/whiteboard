# Module responsible for handling reminders that need to be sent out to users
module ReminderHandler

  # Send the user a reminder to update pages. Reminders are only sent if the
  # page was last updated by the user before the specified date. If the user
  # updated multiple pages before this date, only one email will be sent
  # containing urls to all the pages that need to be updated.
  #
  # ==== Attributes
  #
  # * +updated_before+ - Reminders will only be sent if the page was last
  #   updated before this date.
   def self.send_page_update_reminders (updated_before)
    pages_to_update_by_user_id(updated_before).each do |u_id, pages|
      subject = "Some pages need your attention"
      message = "I noticed that you were the last one to update #{pages.length > 1 ? "these pages" : "this page"}. "
      message += "Please take a few minutes to update #{pages.length > 1 ? "them" : "it"} again."
      urls = self.page_urls_with_labels(pages)

      user = User.find(u_id)
      user.send_reminder(subject, message, urls) unless user.nil?
    end
  end

  # Creates a hash to keep track of pages last updated by a user. Pages that
  # were last updated before the specified date get added to the hash. The
  # key is the ID of the user and the value is an array of page records that
  # were last updated by that user.
  #
  # ==== Attributes
  #
  # * +updated_before+ - Pages that were last updated before this date get
  #   added to the hash.
  def self.pages_to_update_by_user_id updated_before
    pages_by_u_id = {}
    Page.all.each do |page|
      next unless page.updated_at < updated_before

      pages_by_u_id[page.updated_by_user_id] ||= []
      pages_by_u_id[page.updated_by_user_id] << page
    end
    pages_by_u_id
  end

  # Creates a hash that associates page url with the page title like
  # "{ http://whiteboard.sv.cmu.edu/pages/1/edit => Syllabus }".
  #
  # ==== Attributes
  #
  # * +pages+ - Page records
  def self.page_urls_with_labels pages
    urls = {}
    pages.each do |page|
      url = Rails.application.routes.url_helpers::edit_page_url(page.id,
                                                                :host => "whiteboard.sv.cmu.edu")
      urls[url] = page.title
    end
    urls
  end
end
