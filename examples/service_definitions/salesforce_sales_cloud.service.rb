name "Salesfoce Sales Cloud"

has_rest_interface
has_soap_interface
has_xmlrpc_interface

has_browser_interface {
  compatible_browser :firefox do
    min_version "1"
  end

  compatible_browser :chrome do
    min_version "2"
  end

  compatible_browser :opera do
    min_version "3"
  end
}