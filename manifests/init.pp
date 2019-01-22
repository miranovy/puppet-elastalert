# Class: elastalert
# ===========================
#
# Full description of class elastalert here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class elastalert (
  String $install_dir             = $elastalert::params::install_dir,
  String $config_dir              = $elastalert::params::config_dir,
  String $config_file             = $elastalert::params::config_file,
  String $user                    = $elastalert::params::user,
  String $group                   = $elastalert::params::group,
  String $repo_src                = $elastalert::params::repo_src,
  String $ea_release              = $elastalert::params::ea_release,
  String $elasticsearch_vers      = $elastalert::params::elasticsearch_vers,
  String $elasticsearch_host      = $elastalert::params::elasticsearch_host,
  String $elasticsearch_port      = $elastalert::params::elasticsearch_port,
  String $rules_folder            = $elastalert::params::rules_folder,
  String $run_every               = $elastalert::params::run_every,
  String $buffer_time             = $elastalert::params::buffer_time,
  Optional[String] $aws_profile   = $elastalert::params::aws_profile,
  Optional[String] $es_url_prefix = $elastalert::params::es_url_prefix,
  Boolean $use_ssl                = $elastalert::params::use_ssl,
  Boolean $verify_certs           = $elastalert::params::verify_certs,
  Boolean $proxy           = $elastalert::params::verify_certs,
  String $es_send_get_body_as     = $elastalert::params::es_send_get_body_as,
  Optional[String] $es_username   = $elastalert::params::es_username,
  Optional[String] $es_password   = $elastalert::params::es_password,
  Optional[String] $pip_proxy     = $elastalert::params::pip_proxy,
  String $alert_time_limit        = $elastalert::params::alert_time_limit,
)inherits ::elastalert::params
{

  # validate parameters here

  class { '::elastalert::install': } ->
  class { '::elastalert::config': } ~>
  class { '::elastalert::service': } ->
  Class['::elastalert']
}
