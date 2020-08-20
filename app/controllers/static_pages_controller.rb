# Controller responsible for rendering static pages
class StaticPagesController < ApplicationController

  # Method responsible for rendering the 'Accessibility statement' page
  def show_accessibility_statement
    render('static_pages/accessibility_statement/show')
  end

end
