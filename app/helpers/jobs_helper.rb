module JobsHelper

  def job_person_names(job_persons)
    names = ""
    job_persons.each do |person|
      names << "<a href='http://whiteboard.sv.cmu.edu/people/#{person.twiki_name}' target='_top'>#{person.human_name}</a>, "
    end
    names = names[0..-3]
  end

  def job_title_formatted(job)
    if job.is_accepting
      job.title
    else
      return "<strike>#{job.title}</strike>"
    end
  end

end