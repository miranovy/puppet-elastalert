require 'spec_helper'

describe 'elastalert::config' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end
        let(:pre_condition) {
          'include elastalert'
        }
        context 'creates the config dir' do
          it do
            is_expected.to contain_file('/etc/elastalert').with(
              'ensure' => 'directory',
              'owner'  => 'elastalert',
              'group'  => 'elastalert',
              'mode'   => '0660',
              )
          end
          it do
            is_expected.to contain_file('/etc/elastalert/rules.d')
          end
        end
        # TODO: test content of template file
        context 'creates config file' do
          it do
            is_expected.to contain_file('/etc/elastalert/config.yaml').with(
              'ensure' => 'present',
              'owner'  => 'elastalert',
              'group'  => 'elastalert',
              'mode'   => '0660',
              )
          end
        end
      end
    end
  end
end
