
namespace :whiteboard do
  desc "One time script for cleaning up the user profile bio and About me data"
  task(:cleanup_user_bio_data => :environment) do
      # we are keeping the biography column in the database
      # we are relegating the user_text column in the database
      users_that_need_scrubbing = User.where("users.biography != '' OR users.biography IS NOT NULL OR users.user_text != '' OR users.user_text IS NOT NULL ")
                                      # .where(:twiki_name => "KaushikGopal")
          users_that_need_scrubbing.each do |u|
              # clean up the data in biography
              # remove boing boing text
              u.biography = nil if u.biography.starts_with? "<p>I was raised by sheepherders on the hills of BoingBoing"

              # clean up the data in user_text
              # remove "<h2>About Me</h2>"
              u.user_text.gsub!("<h2>About Me</h2>", "") unless u.user_text.blank?
              u.user_text.gsub!("<p>I'd like to accomplish the following three goals (professional or personal) by the time I graduate:<ol><li>Goal 1</li><li>Goal 2</li><li>Goal 3</li></ol></p>", "") unless u.user_text.blank?
              # <h2>About Me</h2><p>I'd like to accomplish the following three goals (professional or personal) by the time I graduate:<ol><li>Goal 1</li><li>Goal 2</li><li>Goal 3</li></ol></p>

              # copy user_text data into biography
              if u.biography.blank?
                  u.biography = u.user_text unless u.user_text.blank?
              else
                  u.biography << u.user_text unless u.user_text.blank?
              end

              # clear text from user_text field
              # u.user_text = nil
              u.save!
          end
    end
end