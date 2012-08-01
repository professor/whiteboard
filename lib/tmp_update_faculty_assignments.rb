require 'pg'

# To run this file on production
#
# heroku console
#  `ruby lib/tmp_update_faculty_assignments.rb`
#
#
# This code isn't pretty, but it works.


module TmpUpdateFacultyAssignments


def self.connect(db, user, pw)
   PGconn.new('localhost', 5432, '', '', db, user, pw)
 end

def self.connect_database_url(url)
  parts = /(.*)\:\/\/(.*)\:(.*)\@(.*)\/(.*)/.match(url)
  puts "parts 4: #{parts[4]}"
  puts "parts 5: #{parts[5]}"
  puts "parts 2: #{parts[2]}"
  puts "parts 3: #{parts[3]}"
  PGconn.new(parts[4], 5432, '', '', parts[5], parts[2], parts[3])
 end




def self.query_table(conn)

  sql = "SELECT courses.id , primary_faculty_id as faculty_id
                      FROM courses, teams
                      WHERE courses.id = teams.course_id
                      UNION
                      SELECT courses.id, Secondary_faculty_id as faculty_id
                      FROM courses, teams
                      WHERE courses.id = teams.course_id"

  result = conn.exec(sql)

  n=0
  result.each do |row|
    course_id = row['id']
    faculty_id = row['faculty_id']

    next if faculty_id.nil?

    sql2 = "SELECT * FROM faculty_assignments WHERE faculty_assignments.course_id = #{course_id} AND faculty_assignments.person_id = #{faculty_id}"
    result2 = conn.exec(sql2)

    if result2.values.length > 0
      puts "Course_id => #{course_id} and faculty_id => #{faculty_id} present in faculty assignments"

    else
      puts "Course_id => #{course_id} and faculty_id => #{faculty_id} not present in faculty assignments"
      now = Time.now
      sql3 = "INSERT INTO faculty_assignments (course_id, person_id, created_at, updated_at)
                               VALUES ('#{course_id}','#{faculty_id}','#{now}','#{now}')"
      result3 = conn.exec(sql3)
      if result3
        n += 1
        puts "successfully added #{n} records"
      else
        puts "oops couldn't write"
      end

    end
  end
  result.clear

end

  end


# Query
#def self.update_faculty_assignments_table
  begin
#    conn = TmpUpdateFacultyAssignments.connect('cmu_education', 'cruise', 'c0ntr0l')
    conn = TmpUpdateFacultyAssignments.connect_database_url(ENV['DATABASE_URL'])
    puts "Connected to #{conn.db} at #{conn.host}"
    TmpUpdateFacultyAssignments.query_table(conn)
  rescue PGError => e
    puts "Eeeeeeeek!", e
  ensure
    conn.close unless conn.nil?
    puts "Connection closed"
  end
#end

