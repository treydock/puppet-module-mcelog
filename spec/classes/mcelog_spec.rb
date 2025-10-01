# frozen_string_literal: true

require 'spec_helper'

describe 'mcelog' do
  on_supported_os.each do |os, facts|
    context "when #{os}" do
      let(:facts) do
        facts
      end

      service_name = if facts[:os]['release']['major'] == '6'
                       'mcelogd'
                     else
                       'mcelog'
                     end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('mcelog') }
      it { is_expected.to contain_class('mcelog::params') }

      it do
        is_expected.to contain_package('mcelog').with(
          ensure: 'present',
          name: 'mcelog',
          before: 'File[mcelog.conf]',
        )
      end

      it do
        is_expected.to contain_file('mcelog.conf').with(
          ensure: 'file',
          path: '/etc/mcelog/mcelog.conf',
          owner: 'root',
          group: 'root',
          mode: '0644',
          notify: 'Service[mcelog]',
        )
      end

      it { is_expected.to have_ini_setting_resource_count(0) }

      it do
        is_expected.to contain_service('mcelog').with(
          ensure: 'running',
          enable: 'true',
          name: service_name,
          hasstatus: 'true',
          hasrestart: 'true',
        )
      end

      context 'with settings defined' do
        let(:params) do
          {
            settings: {
              '' => { 'filter' => 'yes' },
              'server' => { 'client-user' => 'root' },
            },
          }
        end

        it { is_expected.to have_ini_setting_resource_count(2) }

        it do
          is_expected.to contain_ini_setting('/etc/mcelog/mcelog.conf [] filter').with(
            ensure: 'present',
            section: '',
            setting: 'filter',
            value: 'yes',
            path: '/etc/mcelog/mcelog.conf',
            require: 'Package[mcelog]',
            notify: 'Service[mcelog]',
          )
        end

        it do
          is_expected.to contain_ini_setting('/etc/mcelog/mcelog.conf [server] client-user').with(
            ensure: 'present',
            section: 'server',
            setting: 'client-user',
            value: 'root',
            path: '/etc/mcelog/mcelog.conf',
            require: 'Package[mcelog]',
            notify: 'Service[mcelog]',
          )
        end
      end

      context 'with ensure => absent' do
        let(:params) { { ensure: 'absent' } }

        it { is_expected.to contain_package('mcelog').with_ensure('absent') }
        it { is_expected.to contain_file('mcelog.conf').with_ensure('absent') }

        it do
          is_expected.to contain_service('mcelog').with(
            ensure: 'stopped',
            enable: 'false',
          )
        end
      end
    end
  end
end
