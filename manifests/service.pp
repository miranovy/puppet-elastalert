# == Class elastalert::service
#
# This class is meant to be called from elastalert.
# It ensure the service is running.
#
# use template to set up service
class elastalert::service (
  $user        = $elastalert::user,
  $group       = $elastalert::group,
  $install_dir = $elastalert::install_dir,
  $config_dir  = $elastalert::config_dir,
  $config_file = $elastalert::config_file,
  $virtualenv  = $elastalert::virtualenv,
  ){

  file {'/lib/systemd/system/elastalert.service':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('elastalert/elastalert.service.erb')
  }

  service { 'elastalert':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
