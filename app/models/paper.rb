class Paper < ActiveRecord::Base

  has_and_belongs_to_many :people, :join_table=>"papers_people", :class_name => "Person"

    validates_presence_of     :citation

    has_attached_file :paper,
      :storage => :s3,
      :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
      :path => "papers/:id/:filename"
      #:path => ":provider/:attachment/:id_:style.:extension",
 #     :url  => "papers/:id/:basename.:extension",
 #     :path => ":rails_root/public/papers/:id/:basename.:extension"




  def after_initialize
    self.year ||= Date.today.year
    self.date ||= Date.today
  end

  def before_save
    self.title = ends_with_period(self.title)
    self.conference = ends_with_period(self.conference)
    self.authors_full_listing = ends_with_period(self.authors_full_listing)
  end
  
  def ends_with_period(string)
     return if string.nil?
     white_spaces_removed = string.strip()
     return white_spaces_removed if white_spaces_removed.ends_with?('.')
     return white_spaces_removed + "."
  end

  def update_authors(authors)
    self.people = []
    return "" if authors.nil?

    msg = ""
    authors.each do |name|
       person = Person.find_by_human_name(name)
       if person.nil?
         all_valid_names = false
         msg = msg + "'" + name + "' is not in the database. "
         #This next line doesn't quite seem to work
         self.errors.add(:person_name, "Person " + name + " not found")
       else
         self.people << person
       end
    end
    return msg
  end



end
