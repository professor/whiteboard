# Module responsible for handling reminders that need to be sent out to users
module ReminderHandler

  # Send users a reminder to update pages. Reminders are only sent if the
  # page was last updated by the user on this day and month in previous years.
  # If the user updated multiple pages on that day, only one email will be sent
  # containing urls to all the pages that need to be updated. Reminders for pages
  # that were last updated on Feb 29th in previous years will be sent out on Feb 28
  #
  # ==== Attributes
  #
  # * +ref_time+ - Time value used for reference. Reminders will only be sent if the
  #   page was last updated on this day and month but in previous years.
   def self.send_page_update_reminders ref_time
    pages_to_update_by_user_id(ref_time).each do |user, pages|
      options = {
        :subject => "Some pages need your attention",
        :message => "I noticed that you were the last one to update #{pages.length > 1 ? "these pages" : "this page"}. " +
                  "Please take a few minutes to update #{pages.length > 1 ? "them" : "it"} again.",
        :urls => self.page_urls_with_labels(pages),
        :to => user.email
      }
      ReminderMailer.email(options).deliver
    end
  end

  # Creates a hash to keep track of pages last updated by a user. Pages that
  # were last updated on this day and month in previous years get added to the hash.
  # The key is the ID of the user and the value is an array of page records that
  # were last updated by that user.
  #
  # ==== Attributes
  #
  # * +ref_time+ - Time value used for reference. Reminders will only be sent if the
  #   page was last updated on this day and month but in previous years.
  def self.pages_to_update_by_user_id ref_time
    pages_by_u_id = {}
    Page.all.each do |page|
      next if page.updated_at.nil?

      # If page was updated on Feb 29, then use Feb 28 instead for comparison.
      m = page.updated_at.month
      d = (m == 2 && page.updated_at.day == 29) ? 28 : page.updated_at.day
      y = page.updated_at.year

      # Select pages that were updated on 'd' day and 'm' month in previous years
      next unless (d == ref_time.day &&
                   m == ref_time.month &&
                   y < ref_time.year)

      pages_by_u_id[page.updated_by] ||= []
      pages_by_u_id[page.updated_by] << page
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
