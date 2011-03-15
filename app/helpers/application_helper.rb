# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper


  def development?
    @is_development ||=(ENV['RAILS_ENV']=='development')
  end

  def sanitize_trusted(html)
    return sanitize html, :tags => %w(table tbody tr td p br span img a h1 h2 h3 ul ol li em div strong), :attributes => %w(id href name class style)
  end

 
  def scotty_dog_landscape
    image_tag("http://rails.sv.cmu.edu/images/ScottyDogLandscape.jpg", :class => "bevel", :size => "236x69") 
  end
  
  def scotty_dog_portrait
    image_tag("/images/ScottyDog.jpg", :class => "bevel", :size => "214x234")
  end

  #TODO: Consider moving to a partial
  def google_analytics
    return <<RUBY_RUBY_RUBY
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-8300440-1");
pageTracker._trackPageview();
} catch(err) {}</script>    
RUBY_RUBY_RUBY
    
  end

 def image_spacer(width)
  image_tag("/cmu_sv/spacer.gif", :border=>"0", :height=>"1", :width=>width, :alt=>"")
 end

# def left_nav_current_semester_courses
#   current_semester() + " " + Date.today.year
# end


  #Do we need this?
# def current_semester
#    AcademicCalendar.current_semester()
# end

  def add_person_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :people_in_a_collection, :partial => '/people/person_in_a_collection', :object => Person.new
    end
  end


end
