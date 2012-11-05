# This module encapsulates the search functionality and is being extended by the User model.
# This makes sure the controller remains thin and the model does not get fatter.
# This has a method that constructs the query string depending on the search criteria.

module UserSearch

  def construct_query_string(criteria)

    # declare an empty query string
    query_string = ""

    # add filters for main criteria
    if(criteria['main_search_text'] != nil)
      query_string = "("
      # by default add filter for partial search
      main_search_string = "%"+criteria['main_search_text']+"%"
      # add filter for exact match
      if(criteria['exact_match'] != nil)
        main_search_string = criteria['main_search_text']
      end


      if (criteria['first_name'] != nil && criteria['last_name'] != nil)
        # check full name if both first name and last name are selected
        query_string += "human_name ILIKE '"+main_search_string+"'"
      else
        # check first name and add to query string
        if (criteria['first_name'] != nil)
          query_string += "first_name ILIKE '"+main_search_string+"'"
        end
        # check last name and add to query string
        if (criteria['last_name'] != nil)
          query_string += "last_name ILIKE '"+main_search_string+"'"
        end
      end




      # check andrew id and add to query string
      if (criteria['andrew_id'] != nil)
        if( query_string != "(")
          query_string += " OR "
        end
        query_string += "webiso_account ILIKE '"+main_search_string+"'"
      end
      query_string += ")"

    end


    # add filter for company name
    if (criteria['organization_name']!=nil)
      if( query_string != "")
        query_string += " AND "
      end
      query_string += "organization_name ILIKE '%"+criteria['organization_name']+"%'"
    end

    # add filter for program - SE, SE-Tech, SE-DM, SM, INI, ECE
    program_hash = { "masters_program" => nil, "masters_track" => nil }
    if (criteria['program']!=nil)
      if (criteria['program'] == "SE_DM")
        program_hash['masters_program'] = "SE"
        program_hash['masters_track'] = "DM"

      elsif (criteria['program'] == "SE_TECH")
        program_hash['masters_program'] = "SE"
        program_hash['masters_track'] = "TECH"

      else
        program_hash['masters_program'] = criteria['program']
      end
    end

    if (program_hash['masters_program']!=nil)
      if( query_string != "")
        query_string += " AND "
      end
      query_string += "masters_program ILIKE '"+program_hash['masters_program']+"'"
    end


    if (program_hash['masters_track']!=nil)
      if( query_string != "")
        query_string += " AND "
      end
      query_string += "masters_track ILIKE '"+program_hash['masters_track']+"'"
    end


    # add filter for people type - student, staff, alumni
    if (criteria['people_type'] != nil)
      if( query_string != "")
        query_string += " AND "
      end
      query_string += "is_"+criteria['people_type']+" IS true"
      if(criteria['people_type']=='student')

        query_string += " AND is_alumnus IS NOT true"
      end
    end

    # add filter for class year
    if (criteria['class_year'] != nil)
      if( query_string != "")
        query_string += " AND "
      end
      query_string += "graduation_year='"+criteria['class_year']+"'"
    end

    # add filter for full/part time
    if (criteria['is_part_time'] != nil)

      if( query_string != "")
        query_string += " AND "
      end

      # Convert String to Boolean
      if(criteria['is_part_time'].is_a?(String))
        if(criteria['is_part_time'] == 'true')
          criteria['is_part_time'] = true
        elsif(criteria['is_part_time'] == 'false')
          criteria['is_part_time'] = false
        end
      end

      if(criteria['is_part_time'])
        query_string += "is_part_time IS true"
      else
        query_string += "is_part_time IS NOT true"
      end

    end

    # return the constructed query string
    if( query_string != "")
      query_string += " AND "
    end
    return query_string + "is_active IS true"

  end


end
