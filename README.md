Service Description Language - NG
=================================

The SDL-NG is a framework for the description of service properties and the definition of service property vocabularies using simple text-based languages. As the framework is built for tooling simplicity in mind it is especially well suited to capture properties pertinent to businesses, especially for service selection and comparison. Its main application area is the [Open Service Compendium](http://www.open-service-compendium.net), a wiki-like comprehensive database of cloud services.

Overview
========

Service description languages are required by systems such as service registries, directories, and marketplaces for functionalities such as service selection, comparison, and consumption. There are a great number of different service description languages and description approaches in existence, yet most of them face challenges in the areas of tooling simplicity, information redundancy, adaptability or integration ability. Thus, the SDL-NG was created within the [TRESOR Project](http://www.cloud-tresor.com) to tackle these challenge areas.

Design rationale
----------------

The main design goals of the SDL-NG are simple tooling and high practicality when using it to build information systems pertinent to businesses. It does neither strive for high expressiveness (e.g. description logic), nor is built for process automation of service selection or automated reasoning. These choices are made to create an easy to use framework in alternative to other approaches, such as [USDL](http://www.sciencedirect.com/science/article/pii/S0306437912000968), [Linked-USDL](http://linked-usdl.org/), [WSMO4IoS](http://serviceplatform.org/spec/wsmo4ios/), and [GoodRelations](http://www.heppnetz.de/projects/goodrelations/).

The main design constraints for the framework are:

 * A text editor should suffice to create service descriptions and a vocabulary
 * Compared to the other SDLs syntactic and semantic noise should be reduced
 * Concrete serialization technologies should be abstracted, such as XML/XSD, RDF/OWL and EMF/Ecore
 * There is no common answer to "What is a service?". Therefore the structure of service descriptions should be provided by concrete use cases, and not the framework itself
 * The functionality of the framework should be demonstrated on existing services
 * Using a programming language as textual format should allow both static and dynamic information to be available in the same file

Use cases
---------

The following use cases drove the development of the SDL-NG:

 * Supporting the assessment and comparison of services by human users through the creation of a business vocabulary pertinent to businesses, based on empiric research.
 * Dynamically retrieving parts of the description, thus reducing information redundancy
 * Creating a domain-specific service vocabulary by domain-specific marketplaces and service registries
 * Allowing [Linked Data](http://linkeddata.org/) service descriptions

These use cases are implemented in the [TRESOR Open Service Broker](https://github.com/TU-Berlin-SNET/tresor-broker), which includes the SDL-NG framework.

Main Features
=============

This section gives an overview about the main SDL-NG features: the dynamic, textual domain-specific languages, the flexible type system, the export functionality, and the internationalization and documentation features. At the end of this section, the roadmap is presented in detail.

Dynamic, textual domain-specific languages (DSLs)
-------------------------------------------------

There are two areas for which the SDL-NG includes a dynamic, textual DSL: *vocabulary definition* and *service description*. The *vocabulary definition* contains service property definitions, which are used for the purpose of *service description*. The *service description* contains the values of properties of a concrete service. Both DSLs are *dynamic*, i.e., can contain Ruby code blocks to retrieve the property values of a concrete service offering.

The following vocabulary example defines a `CloudServiceModel`-Type, creates named instances of the `CloudServiceModel` and adds two properties to a service definition, the service name and the cloud service model:

```ruby
type :cloud_service_model

cloud_service_model :saas
cloud_service_model :paas
cloud_service_model :iaas

service_properties do
   string :service_name
   cloud_service_model
end
```

After defining this vocabulary, those service properties can be used to describe two service offerings:

```ruby
service_name "Google Drive for Business"
cloud_service_model saas
```

```ruby
service_name "Salesforce Sales Cloud"
cloud_service_model saas
```

The SDL-NG contains an [extensive vocabulary](examples/vocabulary) which was partly modeled after the [Cloud Requirement Framework](https://www.ikm.tu-berlin.de/fileadmin/fg16/Forschungsprojekte/ecis-2012_CLOUD_COMPUTING_FRAMEWORK_-_REQUIREMENTS_AND_EVALUATION_CRITERIA_TO_ADOPT_CLOUD_SERVICES_final_submission.pdf). It contains, for example, definitions that "services can be accessed using a browser" and that "there are different browsers in existence". It is used in the [service description examples](examples/services), e.g. Salesforce Sales Cloud, defines that it can be accessed using Internet Explorer 7+, recent versions of Firefox and Chrome and Safari 5+ on mac.

Flexible value type system
--------------------------



Export functionality
--------------------

Internationalization and documentation features
-----------------------------------------------

Upcoming features
-----------------

Upcoming features include:

 * Definition of service property comparison
 * Input alignment (e.g. matching country to jurisdiction)
 * Property type enforcement / type conversion
 * Feature model based service variant management
 * Modelling of dynamic pricing

Implementation Details
======================

The SDL Framework allows the definition of *vocabulary* and *service descriptions*. The *vocabulary* defines "What can generally be known about any service" (a so called meta-model). *Service descriptions* refer to defined *vocabulary* and define "What is known about a specific service".

Using Ruby code for crazy stuff
-------------------------------

As all service descriptions and vocabulary are Ruby code, any functionality can be integrated into the descriptions.

The following code example uses the helper function `fetch_from_url` which uses Nokogiri to fetch a url and filter it according to a CSS selector to retrieve feature descriptions:

    features = fetch_from_url 'http://www.salesforce.com/sales-cloud/overview/', '.slide h3 + p'

    feature 'Mobile', features[0]
    feature 'Contact Management', features[1]
    feature 'Opportunity Management', features[2]
    feature 'Chatter', features[3]
    feature 'Email Integration', features[4]

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

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
