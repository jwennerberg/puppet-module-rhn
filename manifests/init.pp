# == Class: rhn
#
# Module to manage Red Hat Network connection
#
class rhn (
  $packages             = ['rhnsd','rhn-client-tools'],
  $rhnsd_file_path      = '/etc/sysconfig/rhn/rhnsd',
  $rhnsd_file_owner     = 'root',
  $rhnsd_file_group     = 'root',
  $rhnsd_file_mode      = '0644',
  $rhnsd_interval       = '240',
  $rhnsd_service_ensure = 'running',
  $rhnsd_service_enable = true,
  $rhnsd_service_name   = 'rhnsd',
  $up2date_file_path    = '/etc/sysconfig/rhn/up2date',
  $up2date_file_owner   = 'root',
  $up2date_file_group   = 'root',
  $up2date_file_mode    = '0600',
  $up2date_server_url   = 'https://xmlrpc.rhn.redhat.com/XMLRPC',
  $up2date_ssl_ca_cert  = '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT',
) {

  case $::operatingsystem {
    'RedHat': {
      $rhnsd_service_enable_type = type($rhnsd_service_enable)
      if $rhnsd_service_enable_type == 'string' {
        $rhnsd_service_enabled = str2bool($rhnsd_service_enable)
      } else {
        $rhnsd_service_enabled = $rhnsd_service_enable
      }

      validate_re($rhnsd_service_ensure, '^(running|stopped)$', 'rhn::rhnsd_service_ensure must be set to either running or stopped')
      validate_bool($rhnsd_service_enabled)
      validate_absolute_path($rhnsd_file_path)
      validate_absolute_path($up2date_file_path)
      validate_absolute_path($up2date_ssl_ca_cert)

      package { $packages:
        ensure => 'installed',
      }

      file { 'up2date_file':
        ensure  => 'file',
        path    => $up2date_file_path,
        owner   => $up2date_file_owner,
        group   => $up2date_file_group,
        mode    => $up2date_file_mode,
        content => template('rhn/up2date.erb'),
        require => Package[$packages],
      }

      file { 'rhnsd_file':
        ensure  => 'file',
        path    => $rhnsd_file_path,
        owner   => $rhnsd_file_owner,
        group   => $rhnsd_file_group,
        mode    => $rhnsd_file_mode,
        content => template('rhn/rhnsd.erb'),
        require => Package[$packages],
        notify  => Service['rhnsd_service'],
      }

      service { 'rhnsd_service':
        ensure  => $rhnsd_service_ensure,
        enable  => $rhnsd_service_enabled,
        name    => $rhnsd_service_name,
        require => Package[$packages],
      }
    }
    default: {
      notice("rhn is supported on operatingsystem: RedHat. Your operatingsystem identified as ${::operatingsystem}.")
    }
  }
}
