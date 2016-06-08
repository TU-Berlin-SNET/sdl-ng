##
# A property category.
#
# It is identified by a dot-separated key, e.g. "crf.compliance"
# or "tresor.functionality", which is used for retrieving its
# documentation.
#
# There are static class methods for retrieving a PropertyCategory
# instance for a specific category, as well as retrieving all
# property categories.
#
# The class is also responsible for holding maps of category keys,
# category instances and their associated properties.
class SDL::Base::PropertyClassification::PropertyCategory < SDL::Base::PropertyClassification
  # Maps from key to category instance and category instance
  # to properties.
  @@key_category_map, @@category_properties_map = {}, {}

  def self.key_category_map
    @@key_category_map
  end

  def self.category_properties_map
    @@category_properties_map
  end

  # Retrieve the PropertyCategory instance for a given
  # property. It is guaranteed that the same categories are
  # represented by the same PropertyCategory instances.
  def self.for_property(property)
    if property.loaded_from
      for_key(property.loaded_from.gsub('/', '.'), property)
    else
      for_key('unclassified', property)
    end
  end

  # The category key, e.g. "crf.portability"
  attr :key

  def to_s
    "Property category '#{key}'"
  end

  # All properties belonging to this category
  def properties
    self.class.category_properties_map[self]
  end

  private
    def self.for_key(key, property)
      category_instance = (@@key_category_map[key] ||= PropertyCategory.new(key))

      properties = (@@category_properties_map[category_instance] ||= [])

      properties << property

      category_instance
    end

    def initialize(key)
      @key = key
    end
end