# == Class elastalert::config
#
# This class is called from elastalert for service config.
#
# use template to manage config.yaml
class elastalert::config (
  $user               = $elastalert::user,
  $group              = $elastalert::group,
  $config_dir         = $elastalert::config_dir,
  $rules_folder       = $elastalert::rules_folder,
  $config_file        = $elastalert::config_file,
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
