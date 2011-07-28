module Helpers
  def current_user(stubs = {})
    @current_user ||= mock_model("User", stubs)
  end
end