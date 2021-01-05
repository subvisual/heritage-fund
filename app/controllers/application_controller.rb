# Top-level ApplicationController class, which inherits directly
# from ActionController::Base and is then inherited by all
# other controllers
class ApplicationController < ActionController::Base
  default_form_builder(NlhfFormBuilder)
  include LocaleHelper
  around_action :switch_locale

  # Appends the locale URL parameter to all URLs, where the
  # argument is the current I18n.locale value
  def default_url_options
    {locale: I18n.locale}
  end
end
