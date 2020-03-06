class StaticPagesController < ApplicationController
  def show_accessibility_statement
    render "static_pages/accessibility_statement/show"
  end
end
