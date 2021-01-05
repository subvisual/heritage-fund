class ButtonComponentPreview < ActionView::Component::Preview
  # a most basic button
  def default
    render(ButtonComponent.new)
  end

  # if a 'href' is passed, infers to make the button an 'anchor' tag
  def anchor
    render(ButtonComponent.new(
      href: "#anchor"
    ))
  end

  # props to make it a 'start' button
  def start
    render(ButtonComponent.new(
      is_start_button: true,
      text: "Start"
    ))
  end

  # example of adding additional attributes (or data attributes) to the component
  def attributes
    render(ButtonComponent.new(
      attributes: [
        {attribute: "data-tsiac", value: "true"},
        {attribute: "title", value: "test"}
      ]
    ))
  end

  # makes the button an 'input' element
  def input
    render(ButtonComponent.new(
      text: "Input button",
      element: "input",
      type: "submit"
    ))
  end

  # example of passing beskpoke markup to the innerHTML of the button element
  def custom_html
    render(ButtonComponent.new) do |component|
      %(<strong>Button text</strong>).html_safe
    end
  end

  # example of passing beskpoke markup to the innerHTML of the button element
  # whilst also utilising the a text property that was passed in first
  def custom_html_reading_attribute
    render(ButtonComponent.new(
      text: "Custom button text"
    )) do |component|
      %(<strong>#{component.text}</strong>).html_safe
    end
  end
end
