module LocaleHelper

  # Method to switch locale based on URL argument. This method 
  # is called via the :around_action method contained in 
  # controllers
  def switch_locale(&action)
    locale = I18n.available_locales.map(&:to_s).include?(params[:locale]) ? params[:locale] : I18n.default_locale
    I18n.with_locale(locale, &action)
  end

end
