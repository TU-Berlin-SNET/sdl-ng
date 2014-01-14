require 'rspec'

shared_context 'the default compendium' do
  let :compendium do
    compendium = SDL::Base::ServiceCompendium.new

    compendium.facts_definition do
      type :color do
        string :hex_value
      end

      type :something_other do
        string :some_text
      end

      fact :color do
        color :color
        string :name

        subfact :supercolor do
          string :superpower
        end
      end

      fact :name do
        string :name
      end

      fact :multicolor do
        list_of_colors :colors
      end

      fact :favourite_colors do
        list :favourites do
          color :color
          int :rating
        end
      end
    end

    compendium.type_instances_definition do
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

    compendium.service :blue_service do
      has_color :blue
    end

    compendium.service :red_service do
      has_color :red
    end

    compendium
  end
end