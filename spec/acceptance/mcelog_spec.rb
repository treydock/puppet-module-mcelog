# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'mcelog class:' do
  context 'with default parameters' do
    it 'run successfully' do
      pp = <<-PP
      class { '::mcelog':
        service_ensure => 'stopped',
      }
      PP

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    service_name = if fact('os.release.major').to_s == '6'
                     'mcelogd'
                   else
                     'mcelog'
                   end

    describe package('mcelog') do
      it { is_expected.to(be_installed) }
    end

    describe service(service_name) do
      # Can't run mcelog in docker
      it { is_expected.not_to(be_running) }
      it { is_expected.to(be_enabled) }
    end
  end

  context 'with ensure => absent' do
    it 'run successfully' do
      pp = <<-PP
      class { '::mcelog':
        ensure => 'absent',
      }
      PP

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    service_name = if fact('os.release.major').to_s == '6'
                     'mcelogd'
                   else
                     'mcelog'
                   end

    describe package('mcelog') do
      it { is_expected.not_to(be_installed) }
    end

    describe service(service_name) do
      it { is_expected.not_to(be_running) }
      it { is_expected.not_to(be_enabled) }
    end
  end
end
