require 'spec_helper'

describe 'elastalert::install' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end
        let(:pre_condition) {
          'include elastalert'
        }
        context 'creates the user and group' do
          it do
            is_expected.to contain_group('elastalert').with(
              'ensure' => 'present'
              )
          end
          it do
            is_expected.to contain_user('elastalert').with(
              'ensure' => 'present',
              'system' => true,
              'home'   => '/opt/elastalert',
              'shell'  => '/bin/bash',
              'gid'    => 'elastalert'
            ).that_requires('Group[elastalert]')
          end
        end

        context 'creates the install directory and checks out code' do
          it do
            is_expected.to contain_file('/opt/elastalert').with(
              'ensure' => 'directory',
              'owner'  => 'elastalert',
              'group'  => 'elastalert',
              )
          end
          it do
            is_expected.to contain_file('/opt/elastalert/src').that_requires(
              'File[/opt/elastalert]').with(
              'ensure' => 'directory',
              'owner'  => 'elastalert',
              'group'  => 'elastalert',
              )
          end
          it do
            is_expected.to contain_vcsrepo('/opt/elastalert/src').with(
              'ensure' => 'present',
              'provider' => 'git',
              'source'   => 'https://github.com/Yelp/elastalert.git',
              'revision'  => 'v0.1.10',
              )
          end
        end

        context 'sets up the python stuff' do
          it do
            is_expected.to contain_class('python').with(
              'pip'        => 'present',
              'virtualenv' => 'present',
              'dev'        => 'present',
              )
          end
          it do
            is_expected.to contain_python__virtualenv('/opt/elastalert/elastalert_env').with(
              'ensure' => 'present',
              'owner'  => 'elastalert',
              'group'  => 'elastalert',
              'cwd'    => '/opt/elastalert'
              )
          end
          it do
            is_expected.to contain_exec('setup.py').with(
              'command' => '/opt/elastalert/elastalert_env/bin/python /opt/elastalert/src/setup.py install',
              'creates' => '/opt/elastalert/elastalert_env/bin/elastalert'
              ).that_requires('Python::Virtualenv[/opt/elastalert/elastalert_env]')
          end
          it do
            is_expected.to contain_python__requirements('/opt/elastalert/src/requirements.txt').with(
              'virtualenv' => '/opt/elastalert/elastalert_env',
              'owner'      => 'elastalert',
              'group'      => 'elastalert'
              ).that_requires('Exec[setup.py]')
          end
          it do
            is_expected.to contain_python__pip('elasticsearch').with(
              'ensure'     => '5.3.0',
              'virtualenv' => '/opt/elastalert/elastalert_env',
              'owner'      => 'elastalert',
              'group'      => 'elastalert',
              'pkgname'    => 'elasticsearch',
              )
          end
          context 'creates the elasticsearch index' do
          it do
            is_expected.to contain_exec('elastalert-create-index').with(
              'command' => '/opt/elastalert/elastalert_env/bin/elastalert-create-index -h localhost -p 9200',
              'unless'  => "curl -XHEAD 'localhost:9200/elastalert_status?pretty' | grep '200 OK'",
              )
          end
        end
        end
      end
    end
  end
end
