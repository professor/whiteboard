class StaticController < ApplicationController
  layout 'cmu_sv'

  before_filter :authenticate_user!

end
