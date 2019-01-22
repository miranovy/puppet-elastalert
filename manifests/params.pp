# == Class elastalert::params
#
# This class is meant to be called from elastalert.
# It sets variables according to platform.
#
class elastalert::params {
  $install_dir         = '/opt/elastalert'
  $config_dir          = '/etc/elastalert'
  $config_file         = 'config.yaml'
  $virtualenv          = 'elastalert_env'
  $user                = 'elastalert'
  $group               = 'elastalert'
  $repo_src            = 'https://github.com/Yelp/elastalert.git'
  $ea_release          = 'v0.1.10'
  $elasticsearch_vers  = '5.3.0'
  $elasticsearch_host  = 'localhost'
  $elasticsearch_port  = '9200'
  $rules_folder        = '/etc/elastalert/rules.d'
  $run_every           = 'minutes: 1'
  $buffer_time         = 'minutes: 15'
  $use_ssl             = false
  $verify_certs        = false
  $es_send_get_body_as = 'GET'
  $alert_time_limit    = 'days: 2'
  $aws_profile         = undef
  $es_url_prefix       = undef
  $es_username         = undef
  $es_password         = undef
  $pip_proxy           = undef
}
