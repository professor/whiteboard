# This module encapsulates the search functionality and is being extended by the User model.
# This makes sure the controller remains thin and the model does not get fatter.
# This has a method that constructs the query string depending on the search criteria.

module UserSearch

  def construct_default_query_string(criteria)


    query_string = ""

    if(criteria['main_search_text'] != nil)

      # by default add filter for partial search
      main_search_string = "%"+criteria['main_search_text']+"%"
      # add filter for exact match
      if(criteria['exact_match'] != nil)
        main_search_string = criteria['main_search_text']
      end


      if (criteria['first_name'] != nil && criteria['last_name'] != nil)
        # check full name if both first name and last name are selected
        query_string += "human_name ILIKE ?"
        count = 1
      else
        # check first name and add to query string
        if (criteria['first_name'] != nil)
          query_string += "first_name ILIKE ?"
          # check last name and add to query string
        elsif (criteria['last_name'] != nil)
          query_string += "last_name ILIKE ?"
          #var_list << main_search_string
        end
        count = 1
      end


      # check andrew id and add to query string
      if (criteria['andrew_id'] != nil)
        if( query_string != "")
          query_string += " OR "
          count = 2
        else
          count = 1
        end
        query_string += "regexp_replace(webiso_account, '@andrew.cmu.edu', '') ILIKE ?"

      end


    else
      main_search_string = ""
      count = 0
      query_string = ""
    end
    return {:query_string => query_string, :main_search_string => main_search_string, :count => count}

  end

end
