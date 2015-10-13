require 'json-schema'

##
# A JSON Schema exporter
class SDL::Exporters::JSONSchemaExporter < SDL::Exporters::SchemaExporter
  def export_schema
    schema_hash.to_json
  end

  def schema_hash
    {
      '$schema' => "http://json-schema.org/draft-04/schema#",
      'type' => 'object',
      '$ref' => '#/definitions/Service',
      'definitions' => definitions_schema_hash,
    }.merge(properties_schema_hash(SDL::Base::Type::Service))
  end

  def properties_schema_hash(type)
    {
      'properties' => Hash[
        *type.properties(true).collect do |property|
          [property.name, property_definition_hash(property)]
        end.flatten
      ],
      'description' => type.documentation
    }
  end

  def property_definition_hash(property)
    if property.multi?
      {
          'type' => 'array',
          'items' => single_property_definition_hash(property),
          'description' => property.documentation,
          'category' => property.category.key
      }
    else
      single_property_definition_hash(property)
    end
  end

  def single_property_definition_hash(property)
    if property.simple_type?
      {
          'type' => property.type.json_type,
          'description' => property.documentation,
          'category' => property.category.key
      }
    else
      instances_hash = property.type.subtypes_recursive.collect {|t| t.instances}.reduce{|a, b| a.merge(b)}

      if instances_hash.count == 0
        return {
          'type' => 'object',
          'oneOf' => property.type.subtypes_recursive.collect{|subtype|
            {'$ref' => "#/definitions/#{subtype.local_name}"}
          },
          'description' => property.documentation,
          'category' => property.category.key
        }
      else
        return {
            'enum' => instances_hash.keys.concat([{'description' => Hash[*instances_hash.collect{|k, v| [k, v.documentation]}.flatten]}]),
            'description' => property.documentation,
            'category' => property.category.key
        }
      end
    end
  end

  def definitions_schema_hash
    Hash[
      SDL::Base::Type.subtypes_recursive.drop(1).collect do |type_class|
        [type_class.local_name, properties_schema_hash(type_class)]
      end
    ]
  end
end