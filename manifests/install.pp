# == Class elastalert::install
#
# This class is called from elastalert for install.
#
#
class elastalert::install (
  $install_dir        = $::elastalert::install_dir,
  $config_dir         = $::elastalert::config_dir,
  $config_file        = $::elastalert::config_file,
  $virtualenv         = $::elastalert::virtualenv,
  $user               = $::elastalert::user,
  $group              = $::elastalert::group,
  $repo_src           = $::elastalert::repo_src,
  $ea_release         = $::elastalert::ea_release,
  $elasticsearch_vers = $::elastalert::elasticsearch_vers,
  $elasticsearch_host = $::elastalert::elasticsearch_host,
  $elasticsearch_port = $::elastalert::elasticsearch_port,
  $pip_proxy          = $::elastalert::pip_proxy,
  ){

  group { $group:
    ensure => present,
  }

  user { $user:
    ensure  => present,
    system  => true,
    home    => $install_dir,
    shell   => '/bin/bash',
    gid     => $group,
    require => Group[$group]
  }

  file { $install_dir:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    require => User[$user],
  }

  file { "${install_dir}/src":
    ensure => directory,
    owner  => $user,
    group  => $group,
    require => File[$install_dir],
  }
# clone elastalert repo
# git clone https://github.com/Yelp/elastalert.git
# set revision to github release tag
  vcsrepo {"${install_dir}/src":
    ensure   =>  present,
    provider => 'git',
    source   => $repo_src,
    revision => $ea_release,
    require  => File["${install_dir}/src"]
  }
# install python stuff
# $ python setup.py install
# $ pip install -r requirements.txt
  class { 'python' :
    pip        => 'present',
    virtualenv => 'present',
    dev        => 'present',
  }

  python::virtualenv {"${install_dir}/${virtualenv}":
    ensure  => present,
    owner   => $user,
    group   => $group,
    cwd     => $install_dir,
    proxy   => $pip_proxy,
    require => File[$install_dir]
  }

  exec {'setup.py':
    command => "${install_dir}/${virtualenv}/bin/python ${install_dir}/src/setup.py install",
    path    => "${install_dir}/${virtualenv}/bin:${::path}",
    creates => "${install_dir}/${virtualenv}/bin/elastalert",
    cwd     => "${install_dir}/src",
    user    => $user,
    require => [
      Vcsrepo["${install_dir}/src"],
      Python::Virtualenv["${install_dir}/${virtualenv}"]
    ]
  }

  python::requirements {"${install_dir}/src/requirements.txt":
    virtualenv => "${install_dir}/${virtualenv}",
    owner      => $user,
    group      => $group,
    require    => Exec['setup.py']
  }

  # needed to work around errors in the requirements file
  python::pip { 'requests-oauthlib':
    ensure     => '0.6.1',
    virtualenv => "${install_dir}/${virtualenv}",
    owner      => $user,
    group      => $group,
    pkgname    => 'requests-oauthlib',
    proxy      => $pip_proxy,
  }

  python::pip { 'requests':
    ensure     => '2.10.0',
    virtualenv => "${install_dir}/${virtualenv}",
    owner      => $user,
    group      => $group,
    pkgname    => 'requests',
    proxy      => $pip_proxy,
  }

  python::pip {'elasticsearch':
    ensure     => $elasticsearch_vers,
    virtualenv => "${install_dir}/${virtualenv}",
    owner      => $user,
    group      => $group,
    pkgname    => 'elasticsearch',
    proxy      => $pip_proxy,
  }

  # create elasticsearch index
  exec { 'elastalert-create-index':
    command => "${install_dir}/${virtualenv}/bin/elastalert-create-index -h ${elasticsearch_host} -p ${elasticsearch_port}",
    path    => $facts['path'],
    user    => $user,
    unless  => "curl -I -XHEAD '${elasticsearch_host}:${elasticsearch_port}/elastalert_status?pretty' | grep '200 OK'",
    require => Exec['setup.py'],
  }
}
