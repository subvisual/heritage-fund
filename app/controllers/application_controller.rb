class ApplicationController < ActionController::Base
  default_form_builder(NlhfFormBuilder)
  include LocaleHelper

  # Appends the locale URL parameter to all URLs, where the
  # argument is the current I18n.locale value
  def default_url_options
    { locale: I18n.locale }
  end

end
