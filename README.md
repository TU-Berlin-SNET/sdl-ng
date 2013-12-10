Service Description Language Framework
======================================

This is a framework for the easy description of business aspects of internet services using self defined vocabularies.

Its main features are:

 * Easily understandable and readable "text like" ruby syntax
 * Export of services and vocabulary to XML/XSD and RDF
 * Internationalization of vocabulary descriptions

Upcoming features include:

 * Definition of service property comparison
 * Feature model based service variant management
 * Modelling of dynamic pricing

The SDL Framework is the basis of the TRESOR Broker, and will be supporting the "Open Service Compendium", an envisioned crowdsourced repository for service descriptions, their comparison and brokering.

General Overview
================

The SDL Framework allows the definition of *vocabulary* and *service descriptions*. The *vocabulary* defines "What can generally be known about any service" (a so called meta-model). *Service descriptions* refer to defined *vocabulary* and define "What is known about a specific service".

For example, a *vocabulary* defines that "services can be accessed using a browser" and that "there are different browsers in existence", while the *service description* of a concrete service, e.g. Salesforce Sales Cloud, defines that it can be accessed using Internet Explorer 7+, recent versions of Firefox and Chrome and Safari 5+ on mac. (see `examples/service_definitions/salesforce_sales_cloud.service.rb` for more examples)

The vocabulary
==============

A *vocabulary* defines *fact classes*, *SDL types*, *properties*, and *SDL type instances*.

Fact classes
------------

A *fact class* is a class of possible statements about a service.

Some examples are:

 | Class name        | Statement                                      |
 | ----------------- | ---------------------------------------------- |
 | BrowserInterface  | It can be accessed using a browser             |
 | CloudServiceModel | It can be categorized by a cloud service model |
 | EstablishingYear  | It has a defined year of establishment         |

Every *fact class* is defined by zero or more *properties*.

SDL Types
---------

An SDL *type* is defined by zero or more *properties*, and can be instantiated for referencing purposes.

Properties
----------

*Properties* give more information about facts and types, e.g. the property `year` of `EstablishingYear` defines the year a service was established, the property `cloud_service_model` of `CloudServiceModel` defines the concrete cloud service model. Every property has a name, type, and can be multi valued (a list). Types can be either types wrapping Ruby classes, e.g. dates, durations, strings, numbers and URLs, but also other types.

Examples
========

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

Usage
=====

This chapter describes, how to use the service description framework. It first gives a conceptual overview before ....

Examples can be found in the examples subdirectory. Just run load_data.rb and look at the code.

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
