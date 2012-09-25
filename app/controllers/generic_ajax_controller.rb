class GenericAjaxController < ApplicationController

  before_filter :authenticate_user!

  def update_model_with_value
    model_name = params[:model]
    id = params[:id]
    attribute = params[:attribute]
    update_value = params[:value]

# This is an example of what we are doing for an input of User, 1, course_tools_view, "links"
#    instance = "User".constantize.find(1)
#    instance.course_tools_view = "links"

    model = model_name.constantize
    instance = model.find_by_id(id)
    if (instance.nil?)
      return render :text => "#{model_name} does not have a row with an id of #{id}"
    end

    unless instance.attributes.has_key? attribute
      return render :text => "#{model_name} does not have the attribute #{attribute}"
    end

    unless can? :update, instance
      return render :text => "Do not have permission to modify #{model_name}"
    end

    result = instance.update_attribute(attribute, update_value)

    if result
      return render :text => "Success"
    else
      return render :text => "Failure on update_attribute"
    end


  end


end
