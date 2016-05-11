# base
service_name 'IBM SoftLayer'

# characteristics
cloud_service_model iaas
service_category vm

# charging
#To do: Charging by user account?

minimum_billing_cycle per_hour, '$0.038'
minimum_billing_cycle per_month, '$25.00'

# compliance
public_service_level_agreement 'http://static.softlayer.com/SoftLayer4/pdfs/sla.pdf'
#SLA is incorporated into MSA (Master Services Agreement): http://cdn.softlayer.com/SoftLayer_MSA.pdf
#To Do: Introduce MSA (Master Services Agreement)
status_page 'http://status.softlayer.com/'

# delivery
is_billed monthly
is_charged in_advance
payment_option credit_card
payment_option paypal

# dynamics

# interop
documentation 'http://knowledgelayer.softlayer.com/'

rest_interface 'http://sldn.softlayer.com/article/rest'
xmlrpc_interface 'http://sldn.softlayer.com/article/XML-RPC'
soap_interface 'http://sldn.softlayer.com/article/SOAP'

# optimizing
feedback_page 'http://forums.softlayer.com/'
maintenance_notification user_portal
#To DO: Include Customer Support

# protection
is_protected_by vpn

#provider management
free_trial yes, '1 month'

# reliability

# reputation
established_in 2005

# trust
provider do
  #To Do: Include Press and News Release 'http://www.softlayer.com/press'
  #To Do: Find more company info

  partner_network 'http://www.softlayer.com/customer-stories'
  provider_announcement 'http://www.softlayer.com/press'

  reference_customer 'Ahrefs', 'http://cdn.softlayer.com/case-studies/Ahrefs_Case-Study.pdf'
  reference_customer 'BodyLogicMD', 'http://cdn.softlayer.com/case-studies/BodyLogic_Case-Study.pdf'
  reference_customer 'ChannelPace', 'http://cdn.softlayer.com/case-studies/ChannelPace_Case_Study.pdf'
  reference_customer 'ClickTale', 'http://cdn.softlayer.com/case-studies/ClickTale-Case-Study.pdf'
  reference_customer 'Coriell Life Sciences', 'http://cdn.softlayer.com/case-studies/CoriellLife-Case-Study.pdf'
  reference_customer 'GoCardless', 'http://cdn.softlayer.com/case-studies/GoCardless_Case-Study.pdf'
  reference_customer 'HotlesCombined.com', 'http://cdn.softlayer.com/case-studies/ss-HotelsCombined-Case-Study.pdf'
  reference_customer 'KUULUU', 'http://cdn.softlayer.com/case-studies/ss-KUULUU-Case-Study.pdf'
  reference_customer 'Magma Mobile', 'http://cdn.softlayer.com/case-studies/ss-Magma-Mobile-Box-Case-Study.pdf'
  reference_customer 'MobFox', 'http://www.softlayer.com/SoftLayer4/pdfs/MobFox_Case_Study.pdf'
  reference_customer 'Motion Elements', 'http://cdn.softlayer.com/case-studies/MotionElements_Case_Study.pdf'
  reference_customer 'NexGen', 'http://cdn.softlayer.com/case-studies/ss-NexGen-Case-Study.pdf'
  reference_customer 'Nexmo', 'http://cdn.softlayer.com/case-studies/Nexmo_Case-Study.pdf'
  reference_customer 'Opera Response', 'http://cdn.softlayer.com/case-studies/OperaResponse-Case-Study.pdf'
  reference_customer 'Pagoda Box', 'http://cdn.softlayer.com/case-studies/ss-Pagoda-Box-Case-Study.pdf'
  reference_customer 'PeopleBrowsr', 'http://cdn.softlayer.com/case-studies/ss-PeopleBrowsr-Case-Study.pdf'
  reference_customer 'SK Planet', 'http://cdn.softlayer.com/case-studies/SKPlanet-Case-Study.pdf'
  reference_customer 'SparkCognition', 'http://cdn.softlayer.com/case-studies/SparkCognition-Case-Study.pdff'
  reference_customer 'Struq', 'http://cdn.softlayer.com/case-studies/ss-Struq-Case-Study.pdf'
  reference_customer 'Ticket.com', 'http://cdn.softlayer.com/case-studies/ss-Tiket-com-Case-Study.pdf'
  reference_customer 'TROPO', 'http://cdn.softlayer.com/case-studies/Tropo-Case-Study.pdf'
  reference_customer 'Ultra Knowledge', 'http://cdn.softlayer.com/case-studies/ss-Ultra-Knowledge-Case-Study.pdf'
  reference_customer 'WorldTicket', 'http://cdn.softlayer.com/case-studies/WorldTicket-Case-Study.pdf'

end

#To Do: Get more information on authorization and authentication
monitoring yes, annotation:'http://www.softlayer.com/server-monitoring'

certification iso_27001
#Softlayer provides soc1,2,3 reports. Same as soc certificates?

#To DO: Star Registrant? EU Model Clauses? PCI Compliance?

transmission_encryption 'SSL'
#To Do: SSL certificates
#To Do: Firewalls

multi_tenancy yes
#How to show different Linux distributions? Seperately or as shown below?
compatible_operating_system windows, 'Microsoft Windows Server'
compatible_operating_system linux, 'CentOS, CloudLinux, Debian GNU/Linux, Ubuntu, Red Hat Enterprise, Vyatta'