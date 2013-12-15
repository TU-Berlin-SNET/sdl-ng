Service Description Language Framework
======================================

This is a framework for the easy description of business aspects of internet services using self defined vocabularies.

Its main features are:

 * Comprehensive textual domain-specific language
 * DSL implemented as Ruby code, allowing flexible use cases (e.g. extracting data from websites)
 * Export of services and vocabulary to XML/XSD and RDF
 * Internationalization of vocabulary descriptions

Upcoming features include:

 * Definition of service property comparison
 * Input alignment (e.g. matching country to jurisdiction)
 * Property type enforcement / type conversion
 * Feature model based service variant management
 * Modelling of dynamic pricing

The main design constraints for the framework are:

 * A text editor should suffice to create service descriptions and vocabulary
 * Compared to other general SDLs, e.g. USDL, Linked-USDL, and OWL-S syntactic and semantic noise should be reduced
 * Concrete serialization technologies should be abstracted, such as XML/XSD, RDF/OWL and EMF/Ecore
 * There is no common answer to "What is a service?". Therefore the structure of service descriptions should be provided by concrete use cases, and not the framework itself
 * The functionality of the framework should be demonstrated on existing services
 * Using a programming language as textual format should allow both static and dynamic information to be available in the same file

The SDL Framework is the basis of the TRESOR Broker, and will be supporting the "Open Service Compendium", an envisioned crowdsourced repository for service descriptions, their comparison and brokering.

General Overview
================

The SDL Framework allows the definition of *vocabulary* and *service descriptions*. The *vocabulary* defines "What can generally be known about any service" (a so called meta-model). *Service descriptions* refer to defined *vocabulary* and define "What is known about a specific service".

For example, a *vocabulary* defines that "services can be accessed using a browser" and that "there are different browsers in existence", while the *service description* of a concrete service, e.g. Salesforce Sales Cloud, defines that it can be accessed using Internet Explorer 7+, recent versions of Firefox and Chrome and Safari 5+ on mac. (see `examples/service_definitions/salesforce_sales_cloud.service.rb` for more examples)

The vocabulary
--------------

A *vocabulary* defines *fact classes*, *SDL types*, *properties*, and *SDL type instances*.

Any fact class, property value and type instance can be *annotated* with arbitrary data to capture "fine-print" of descriptions.

### Fact classes

A *fact class* is a class of possible statements about a service. Some examples are:

| Class name              | Statement                                      |
| ----------------------- | ---------------------------------------------- |
| BrowserInterface        | It can be accessed using a browser             |
| CloudServiceModel       | It can be categorized by a cloud service model |
| CommunicationProtection | It is protected by a communication protection  |
| EstablishingYear        | It has a defined year of establishment         |

### SDL Types and type instances

An *SDL type* is used for structuring fact information.

Within a vocabulary, SDL types can be instantiated. These *SDL type instances* can be easily referred to from fact instances by their name. This allows different service descriptions to refer to the same instances.

The following table shows some examples of types, their purpose, and predefined instances:

| Type name               | Used with               | Description                            | Instances             |
| ----------------------- | ----------------------- | -------------------------------------- | --------------------- |
| Browser                 | BrowserInterface        | A web browser                          | Firefox, Chome, Opera |
| CloudServiceModel       | CloudServiceModel       | A cloud service model                  | SaaS, PaaS, IaaS      |
| CommunicationProtection | CommunicationProtection | A way to protect service communication | VPN, HTTPS            |

### Fact and Type Properties

*Properties* give more information about facts and types. Every property has a name, type, and can be multi valued (a list).

Some example properties are:

| Defined on                     | Name                     | Type                    | Multi-valued | Definition                                  |
| ------------------------------ | ------------------------ | ----------------------- | ------------ | ------------------------------------------- |
| BrowserInterface (Fact)        | compatible_browsers      | CompatibleBrowser       | Yes          | A list of compatible browsers               |
| CompatibleBrowser (Type)       | browser                  | Browser                 | No           | A browser                                   |
| Browser (Type)                 | url                      | URL                     | No           | The URL of a Browser                        |
| CloudServiceModel (Fact)       | cloud_service_model      | CloudServiceModel       | No           | The cloud service model                     |
| CommunicationProtection (Fact) | communication_protection | CommunicationProtection | No           | The communication protection of the service |
| EstablishingYear (Fact)        | year                     | Integer                 | No           | The year a service was established          |

Types can be either types wrapping Ruby classes, e.g. dates, durations, strings, numbers and URLs, and also other SDL types.

Service Descriptions
--------------------

A *service description* uses *fact classes*, *types*, and *type instances* to describe services.

Vocabulary Syntax
=================

This chapter defines the syntax of vocabularies.

Fact class and type definition
------------------------------

The fact class and type definition are very similar.

This is how fact classes are defined:

`fact` *\<symbolic name>* `do`

> *\<Fact properties and subfacts>*

`end`

And this is how types are defined:

`type` *\<symbolic name>* `do`

> *\<Type properties and subtypes>*

`end`

Every fact class and type definition is identified by its *symbolic name*, for which the SDL framework creates a Ruby class:

| Symbolic name         | Ruby class constant name    |
| --------------------- | --------------------------- |
| `:name`               | `Name`                      |
| `:payment_option`     | `PaymentOption`             |
| `:compatible_browser` | `CompatibleBrowser`         |
| `:browser`            | `Browser`                   |

The definition block includes *properties* and *subclasses* of fact classes and types respectively.

Property definition
-------------------

Fact and type properties are defined according to the following pattern:

*\<type>* *\<name>*

*\<type>* can refer either to a *wrapped type* or another SDL *type*.

*Wrapped types* wrap Ruby classes. The following are available (see `lib/sdl/types`):

| Wrapped Ruby Type       | Referenced as              |
| ----------------------- | -------------------------- |
| String                  | `string`, `str`            |
| Integer                 | `number`, `integer`, `ìnt` |
| Time                    | `datetime`                 |
| ActiveSupport::Duration | `duration`                 |
| URI                     | `uri`, `url`               |

*SDL types* are referred by their name, e.g. `payment_option` references `PaymentOption`.

Properties can be multi valued, denoted by a `list_of_` prefix, e.g. `list_of_strings` or `list_of_browsers`.

*\<name>* can be omitted, if it is the same as the name of the type. The following type definitions are equal

    url

equals

    url :url

Type instances definition
-------------------------

Predefined type instances are created using the following pattern:

*\<type reference>* *\<symbolic name>* `do`

> *\<property definition>*

`end`

If a browser type is defined as such:

    type :browser do
      url
    end

Instantiating browsers can be done like this:

    browser :firefox do
      url 'http://www.mozilla.org/firefox/'
    end

    browser :chrome do
      url 'https://www.google.com/chrome'
    end

    browser :internet_explorer do
      url 'http://windows.microsoft.com/en-US/internet-explorer/download-ie'
    end

Subtype and subfact definition
------------------------------

As types and facts are Ruby classes, they can be inherited.

This is how subclasses of fact classes are defined:

`fact` *\<symbolic name>* `do`

> `subfact` *\<symbolic name>* `do`

> > *\<Subfact properties and further subfacts>*

> `end`

`end`

It is very similar to subclasses of type classes:

`type` *\<symbolic name>* `do`

> `subtype` *\<symbolic name>* `do`

> > *\<Subtype properties and further subtypes>*

> `end`

`end`

Service definition syntax
=========================

The service definition contains any number of lines following the pattern:

*\<fact class reference>* *\<property setting instructions>*

There are different ways how to reference facts and set property values, shown in the following subsections.

Fact class reference
--------------------

Fact classes can be referred by three different mechanisms: either *`has_`\<fact name>*, or *\<fact name>*, or  *`is_`\<past perfective of fact name as verb>*. This allows choosing a term which has the highest readability for a certain fact class.

The following table contains some examples:

| Fact class | *`has_`\<fact name>* | *\<fact name>* | *`is_`\<past perfective of fact name as verb>* |
| ---------- | -------------------- | -------------- | ---------------------------------------------- |
| `Name`     | `has_name`           | `name`         | `is_named`                                     |
| `Bill`     | `has_bill`           | `bill`         | `is_billed`                                    |
| `Feature`  | `has_feature`        | `feature`      | `is_featured`                                  |

Property setting instructions
-----------------------------

Setting the values of fact and type properties can be done in two ways:

### Short form

If a fact or type has only some properties, setting properties can be done by specifying their values in the order they appear in the vocabulary:

*\<fact or type reference>* *\<first value>*, *\<second value>*, *\<n-th value>*

The following example (taken from `examples/service_definitions/google_drive_for_business.service.rb`) illustrates this mechanism:

    name 'Google Drive for Business'

    has_add_on_repository 'https://www.google.com/enterprise/marketplace/home', 1000

If properties should be set in a different order, the property names can be specified as:

*\<fact or type reference>* *\<name>* `:` *\<value>*, *\<name>* `:` *\<value>*, ...

An example would be:

    has_documentation url: 'http://www.salesforce.com/sales-cloud/overview/'

The default Ruby syntax applies for creating lists: `[` *\<item 1>* `, ` *\<item 2>* `, ` *\<item n>* `]`

It should be obvious that the order of values has to change if the order of properties changes.

### Block form

If a fact or type has many properties, setting those can be done as a block:

*\<fact or type reference>* `do`

> *\<name>* *\<value>*

`end`

The following example (see `examples/service_definitions/salesforce_sales_cloud.service.rb`) illustrates this mechanism:

    has_add_on_repository do
      url 'https://appexchange.salesforce.com/'
      number_of_add_ons 2000
    end

Multi-valued properties are created by specifying the name more than once, for example:

    has_browser_interface do
      compatible_browser ...
      compatible_browser ...
      compatible_browser ...
      compatible_browser ...
    end

### Combining both methods

Both methods can be combined:

*\<fact or type reference>* *\<property setting instructions>* `do`

> *\<name>* *\<value>*

`end`

So the example of the previous subsection can be rewritten as:

    has_add_on_repository 'https://appexchange.salesforce.com/' do
      number_of_add_ons 2000
    end

Referencing type instances
--------------------------

Type instances can be referred to by using *name*, as for example:

    has_cloud_service_model saas

Due to the inner workings of the framework, if there are different instances with the same *name*, then the name has to be prepended by a colon (`:`), for example:

    has_cloud_service_model :saas

Annotating data
---------------

Annotations can be used to capture the "fine-print" of service descriptions.

By adding `annotation: ` *annotation* any property value definition and fact instance can be annotated, for example:

    has_cloud_service_model :saas, annotation: "Unless you are Deutsche Bank"

    has_add_on_repository 'https://appexchange.salesforce.com/' do
      number_of_add_ons 2000, annotation: "... and rising every minute"
    end

Using Ruby code for crazy stuff
-------------------------------

As all service descriptions and vocabulary are Ruby code, any functionality can be integrated into the descriptions.

The following code example uses the helper function `fetch_from_url` which uses Nokogiri to fetch a url and filter it according to a CSS selector to retrieve feature descriptions:

    features = fetch_from_url 'http://www.salesforce.com/sales-cloud/overview/', '.slide h3 + p'

    has_feature 'Mobile', features[0]
    has_feature 'Contact Management', features[1]
    has_feature 'Opportunity Management', features[2]
    has_feature 'Chatter', features[3]
    has_feature 'Email Integration', features[4]

Interfacing with the framework
==============================

As the framework is to be used within other applications, there is no mening to "running" it.

Nevertheless, there is a GEM binary, `process_service_descriptions` provided, which does the following:

  * Load translations from the `translations` directory
  * Load all vocabulary definitions from the `vocabulary` directory
  * Use this vocabulary to process all service descriptions from a `services` directory
  * Output XML/XSD, RDF and Markdown to the `output` directory

This binary can be used within the `examples` subdirectory of this GEM.

Examples
========

To run all examples, execute the GEM binary `process_service_descriptions` within the `examples` subdirectory of this GEM.

Google Drive for Business
-------------------------

Included from `examples/service_definitions/google_drive_for_business.service.rb`

{include:file:examples/service_definitions/google_drive_for_business.service.rb}

Salesforce Sales cloud
----------------------

Included from `examples/service_definitions/salesforce_sales_cloud.service.rb`

{include:file:examples/service_definitions/salesforce_sales_cloud.service.rb}

The most basic example
----------------------

This vocabulary specifies that services can have an availability, expressed as an integer:

    fact :availability do
        integer :availability
    end

This defines a Fact class `Availability`, with an integer property `availability` which can be instantiated within service descriptions as:

    has_availability 100

or just

    availability 100

If `service` would be a service description object, this would output `100`

    puts service.availability

The definition of color
-----------------------

The following type class definition is used to specify that the type `:color` is defined by a hexadecimal value, stored in a string.

    type :color do
        string :hex_value
    end

It is now possible to define instances of this type and assign them symbolic names, such as `red`, `green` or `blue`:

    color :red do
        hex_value '#F00'
    end

    color :green do
        hex_value '#0F0'
    end

    color :blue do
        hex_value '#00F'
    end

After definition of types, a service fact class can be defined, referring to this type.

    fact :color do
        color :color
    end

Now, differently colored services can be described, e.g.:

    red_service.service.rb:
        has_color :blue

    green_service.service.rb:
        has_color :green

    blue_service.service.rb:
        has_color :blue

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
