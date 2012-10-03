module ApplicationHelper


  def sanitize_trusted(html)
    return sanitize html, :tags => %w(a br div em h1 h2 h3 h4 img span p pre strong table tbody tr td ul ol li), :attributes => %w(bgcolor cellpadding cellspacing class href id name padding src style valign width)
  end


  def scotty_dog_landscape
    image_tag("http://rails.sv.cmu.edu/images/ScottyDogLandscape.jpg", :class => "bevel", :size => "236x69")
  end

  def scotty_dog_portrait
    image_tag("/images/ScottyDog.jpg", :class => "bevel", :size => "214x234")
  end

  def image_spacer(width)
    image_tag("/cmu_sv/spacer.gif", :border => "0", :height => "1", :width => width, :alt => "")
  end

  # def left_nav_current_semester_courses
  #   current_semester() + " " + Date.today.year
  # end

  def professor_image
    image_tag("/images/professor.jpg", :size => "50x50", :border => "0", :alt => "These fields can be edited by a faculty role", :title => "Faculty role")
  end

  def admin_image
    image_tag("/images/admin.jpg", :size => "50x50", :border => "0", :alt => "These fields can be edited by an admin role", :title => "Admin role")
  end

  #Do we need this, used on welcome page
  def current_semester
    AcademicCalendar.current_semester()
  end

  def format_timestamp(timestamp)
    return "" if timestamp.nil?
    content_tag(:span, "#{time_ago_in_words(timestamp)} ago", :class => 'timestamp', :title => timestamp.in_time_zone('Pacific Time (US & Canada)').strftime('%a %b %d %Y, %I:%M %p Pacific Time'))
  end

  def monthname(monthnumber)
    if monthnumber
      Date::MONTHNAMES[monthnumber]
    end
  end

  def display_timestamp(timestamp, options = {})

    return "" if timestamp.nil?
    content_tag(:span, "#{timestamp.in_time_zone('Pacific Time (US & Canada)').strftime('%a %b %d %Y, %I:%M %p (Pacific)')}", options)

  end


end
