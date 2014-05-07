require 'rspec'

shared_context 'the default compendium' do
  let! :compendium do
    @compendium ||= SDL::Base::ServiceCompendium.new

    @compendium.clear!

    @compendium.instance_eval do
      type :color do
        string :hex_value

        subtype :supercolor do
          string :superpower
        end
      end

      type :service_color do
        color :color
        string :name
      end

      type :something_other do
        string :some_text
      end
    end

    @compendium.facts_definition do
      service_color :is_colored

      string :name

      list_of_colors :multicolored

      list :favourite_colors do
        color :color
        int :rating
      end
    end

    @compendium.type_instances_definition do
      color :red do
        hex_value '#F00'
      end

      color :green do
        hex_value '#0F0'
      end

      color :blue do
        hex_value '#00F'
      end

      color :yellow do
        hex_value '#FF0'
      end

      color :text do
        hex_value '#000'
      end

      something_other :text do
        some_text 'This is some text'
      end
    end

    @compendium.service :blue_service do
      is_colored :blue, 'Blue'
    end

    @compendium.service :red_service do
      is_colored :red
    end

    @compendium.service :complex_service do
      name 'Complex Service'

      multicolored :red
      multicolored :green
      multicolored :blue
      multicolored :yellow
      multicolored :text

      favourite_color do
        color :blue
        rating 5

        annotation 'Mathias'
      end

      favourite_color do
        color :green
        rating 10

        annotation 'Sabrina'
      end
    end

    @compendium
  end
end