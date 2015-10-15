##
# A classification scheme for properties, e.g., a property category
# or a category specific property.
class SDL::Base::PropertyClassification
  extend ActiveSupport::Autoload

  autoload :PropertyCategory

  ActiveSupport::Dependencies::Loadable.require_dependency File.join(__dir__, 'property_classification', 'property_category.rb')
end