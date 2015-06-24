# base
service_name 'HP Public Cloud'

# characteristics
cloud_service_model iaas

# charging
is_charged_by user_account

# compliance
status_page 'https://community.hpcloud.com/status'
public_service_level_agreement 'http://www.hpcloud.com/sla'

# delivery
is_billed monthly
is_charged after_use
payment_option credit_card

# dynamics

# interop
documentation 'http://docs.hpcloud.com/publiccloud/overview'

# optimizing
past_release_notes 'http://h20564.www2.hp.com/hpsc/doc/public/display?docId=c04345863'

# protection
is_protected_by vpn

# reliability
can_be_used_offline no

# reputation
established_in 2012

# trust
provider do
  company_type incorporated
  partner_network 'http://www.hp-cloudstories.com/'

  reference_customer 'Digital Planet', 'http://www.hp-cloudstories.com/landing/Digital-Planet-moves-to-the-cloud-with-HP?from=referencehome&extId=&pre=&caid='
  reference_customer 'Swisscom', 'http://www.hp-cloudstories.com/landing/Swisscom-charts-cloud-future-with-a-new-hybrid-delivery-strategy?caid=701b00000005QSV'
  reference_customer 'ING', 'http://www.hp-cloudstories.com/landing/ING-transforms-its-business-with-HP-Converged-Cloud?from=referencehome&extId=&pre=&caid='
  reference_customer 'Telefonica', 'http://www.hp-cloudstories.com/resources/Telefonica-customers-move-faster-with-HP-cloud-solutions---2MIN-VIDEO?from=referencehome&extId=&pre=&caid='
end

#storage_features
storage_features do
  platform_compatibility do
    compatible_operating_system windows, 'Windows Server 2008 SP2, Windows Server 2008 R2'
    compatible_operating_system linux, 'SUSE Linux Enterprise Server 11 v3'
  end
end