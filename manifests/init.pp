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
  $up2date_settings     = {},
) {

  case $::osfamily {
    'RedHat': {
      $rhnsd_service_enable_type = type3x($rhnsd_service_enable)
      if $rhnsd_service_enable_type == 'string' {
        $rhnsd_service_enabled = str2bool($rhnsd_service_enable)
      } else {
        $rhnsd_service_enabled = $rhnsd_service_enable
      }

      validate_re($rhnsd_service_ensure, '^(running|stopped)$', 'rhn::rhnsd_service_ensure must be set to either running or stopped')
      validate_bool($rhnsd_service_enabled)
      validate_absolute_path($rhnsd_file_path)
      validate_absolute_path($up2date_file_path)
      validate_hash($up2date_settings)

      package { $packages:
        ensure => 'installed',
      }

      $up2date_defaults = { 'path' => $up2date_file_path }
      create_ini_settings({ '' => $up2date_settings}, $up2date_defaults)

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
      notice("rhn is supported on osfamily RedHat. Your osfamily identified as ${::osfamily}.")
    }
  }
}
