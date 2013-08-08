module JobsHelper

  def job_person_names(job_persons)
    names = ""
    job_persons.each do |person|
      names << "<a href='/people/#{person.twiki_name}' target='_top'>#{person.human_name}</a>, "
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

  def job_titles_formatted(jobs)
    job_titles = ""
    jobs.each do |job|
      job_titles << "<a href='/jobs/#{job.id}/edit' target='_top'>#{job.title}</a>, "
    end
    job_titles = job_titles[0..-3]
  end

end