require 'spec_helper'

describe 'elastalert::service' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end
        let(:pre_condition) {
          'include elastalert'
        }
        context 'sets up service template' do
          it do
            is_expected.to contain_file('/lib/systemd/system/elastalert.service')
            verify_contents(catalogue, '/lib/systemd/system/elastalert.service', [
              "User=elastalert",
              "Group=elastalert",
              "WorkingDirectory=/opt/elastalert",
              "ExecStart=/opt/elastalert/elastalert_env/elastalert  --config /etc/elastalert/config.yaml"
              ])
          end
        end
        context 'manages the service' do
          it do
            is_expected.to contain_service('elastalert').with(
              'ensure'     => 'running',
              'enable'     => true,
              'hasstatus'  => true,
              'hasrestart' => true,
              )
          end
        end
      end
    end
  end
end
