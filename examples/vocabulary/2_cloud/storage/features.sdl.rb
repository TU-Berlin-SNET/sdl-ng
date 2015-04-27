# additional interfaces
interface :android
interface :ios
interface :java
interface :javascript
interface :net
interface :osx
interface :php
interface :python
interface :ruby

type :sharing

sharing :public_link
sharing :collaboration

type :operating_system

operating_system :windows
operating_system :mac_osx
operating_system :linux

type :mobile_device

mobile_device :android
mobile_device :blackberry
mobile_device :iphone
mobile_device :ipad
mobile_device :kindle
mobile_device :windows_phone

type :platform_compatibility do
  list :compatible_operating_systems do
    operating_system
    string :min_version
  end

  list_of_interfaces
  list_of_mobile_devices
end

type :multi_tenancy do
  boolean :has_multi_tenancy
  number :max_user
end

type :storage_features do
  list_of_sharings
  multi_tenancy
  platform_compatibility
end

service_properties do
  storage_features
end