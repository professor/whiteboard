class Deliverable < ActiveRecord::Base

  has_and_belongs_to_many :people, :join_table=>"deliverables_people", :class_name => "Person"

  has_attached_file :deliverable,
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
    :path => "deliverables/:id/:filename"

  def before_save
    self.submission_date = DateTime.now
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
