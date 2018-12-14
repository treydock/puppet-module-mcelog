require 'spec_helper_acceptance'

describe 'mcelog class:' do
  context 'with default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
      class { '::mcelog':
        service_ensure => 'stopped',
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    if fact('os.release.major').to_s == '6'
      service_name = 'mcelogd'
    else
      service_name = 'mcelog'
    end

    describe package('mcelog') do
      it { should be_installed }
    end

    describe service(service_name) do
      # Can't run mcelog in docker
      it { should_not be_running }
      it { should be_enabled }
    end
  end

  context 'with ensure => absent' do
    it 'should run successfully' do
      pp =<<-EOS
      class { '::mcelog':
        ensure => 'absent',
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    if fact('os.release.major').to_s == '6'
      service_name = 'mcelogd'
    else
      service_name = 'mcelog'
    end

    describe package('mcelog') do
      it { should_not be_installed }
    end

    describe service(service_name) do
      it { should_not be_running }
      it { should_not be_enabled }
    end
  end
end
