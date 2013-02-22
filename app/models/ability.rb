class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end

    can :manage, User, :id => user.id

    can :update, PageAttachment


    if (user.human_name == "Todd Sedano" ||user.human_name == "Chris Zeise" || user.human_name == "Gerry Elizondo")
      can :upload, Course
    end

    if (user.human_name == "Jazz Sabian"  || user.human_name == "Albert Liu" || user.human_name == "Stacy Marshall" || user.human_name == "Todd Sedano")
      can :create, User
    else
      cannot :create, User
    end

    if (user.is_admin? || user.human_name == "Kaushik Gopal")
      can :upload_photo, User
    else
      cannot :upload_photo, User
    end

    #Contracts manager
    if (user.is_admin? || user.human_name == "Ngoc Ho" || user.human_name == "Hector Rastrullo")
      can :manage, SponsoredProjectAllocation
      can :manage, SponsoredProjectEffort
      can :manage, SponsoredProjectSponsor
      can :manage, SponsoredProject
    end

    if (user.is_admin?)
      can :manage, Course
    end
    if  (user.is_staff?)
      can [:teach, :create, :update, :peer_evaluation, :team_formation], Course
      can [:manage ], Assignment
    end
    can [:teach, :update, :peer_evaluation, :team_formation], Course, :faculty => {:id => user.id} #Useful for TAs.

    if (user.human_name == "Todd Sedano" || user.human_name == "Kaushik Gopal")
      can :see_student_grades, Course #experimental feature
    end


    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
