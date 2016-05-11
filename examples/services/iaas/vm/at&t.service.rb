# base
service_name 'AT&T'

# characteristics
cloud_service_model iaas
service_category vm

# charging
is_charged_by user_account

# compliance
status_page 'https://www.synaptic.att.com/clouduser/service_health.htm'
public_service_level_agreement 'http://www.att.com/gen/general?pid=6622'

# delivery
is_billed monthly
is_charged in_advance
payment_option credit_card

# dynamics

# interop
documentation 'https://developer.att.com/apis'

compatible_browser internet_explorer, annotation: 'optimized for AT&T powered by Yahoo!' #can not find the version
compatible_browser firefox, 'recent'
compatible_browser chrome, 'recent'
compatible_browser safari, annotation: 'on Mac' #'5' cannot find the version
#http://www.att.com/esupport/article.jsp?sid=KB402059&cv=801
# dynamic

# optimizing
maintenance_free

# portability

# protection
is_protected_by https

# reliability
can_be_used_offline yes

# reputation
established_in 2004

# trust
provider do
  company_type plc
  employs 243620
  last_years_revenue '6224000000 $'
  report financial_statement, quarterly
end
