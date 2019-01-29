# == Class elastalert::config
#
# This class is called from elastalert for service config.
#
# use template to manage config.yaml
class elastalert::config (
  $user                = $elastalert::user,
  $group               = $elastalert::group,
  $config_dir          = $elastalert::config_dir,
  $rules_folder        = $elastalert::rules_folder,
  $config_file         = $elastalert::config_file,
  $elasticsearch_host  = $elastalert::elasticsearch_host,
  $elasticsearch_port  = $elastalert::elasticsearch_port,
  $use_ssl             = $elastalert::use_ssl,
  $es_username         = $elastalert::es_username,
  $es_password         = $elastalert::es_password,
  $aws_profile         = $elastalert::aws_profile,
  $verify_certs        = $elastalert::verify_certs,
  $es_send_get_body_as = $elastalert::es_send_get_body_as,
  $alert_time_limit    = $elastalert::alert_time_limit,
  )
{

  file { $config_dir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0660',
  }

  file {"${config_dir}/${config_file}":
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0660',
    content => template('elastalert/config.yaml.erb')
  }

  file {$rules_folder:
    ensure => directory,
    owner  => $user,
    group  => $group,
  }
}
