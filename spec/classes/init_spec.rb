require 'spec_helper'

describe 'elastalert' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "elastalert class without any parameters" do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('elastalert::params') }
          it { is_expected.to contain_class('elastalert::install').that_comes_before('Class[elastalert::config]') }
          it { is_expected.to contain_class('elastalert::config') }
          it { is_expected.to contain_class('elastalert::service').that_subscribes_to('Class[elastalert::config]') }
          it { is_expected.to contain_service('elastalert') }
        end
      end
    end
  end
end
