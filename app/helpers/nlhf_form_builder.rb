class NlhfFormBuilder < ActionView::Helpers::FormBuilder
  
  # Helper method to return 'name' attribute
  # e.g. f.name_for :description
  def name_for(method, options = {})
    InstanceTag.new(object_name, method, self, options) \
               .name_for(options)
  end

  # Helper method to return 'id' attribute
  # e.g. f.id_for :description
  def id_for(method, options = {})
    InstanceTag.new(object_name, method, self, options) \
               .id_for(options)
  end
end

class InstanceTag < ActionView::Helpers::Tags::Base
  def id_for(options)
    add_default_name_and_id(options)
    options['id']
  end

  def name_for(options)
    add_default_name_and_id(options)
    options['name']
  end
end