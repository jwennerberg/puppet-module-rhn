# == Class: rhn
#
# Module to manage Red Hat Network connection
#
class rhn (
  $packages                     = ['rhnsd','rhn-client-tools'],
  $rhnsd_file_path              = '/etc/sysconfig/rhn/rhnsd',
  $rhnsd_file_owner             = 'root',
  $rhnsd_file_group             = 'root',
  $rhnsd_file_mode              = '0644',
  $rhnsd_interval               = '240',
  $rhnsd_service_ensure         = 'running',
  $rhnsd_service_enable         = true,
  $rhnsd_service_name           = 'rhnsd',
  $up2date_file_path            = '/etc/sysconfig/rhn/up2date',
  $up2date_settings             = {},
  $up2date_settings_hiera_merge = true,
) {

  case $::osfamily {
    'RedHat': {
      if is_string($rhnsd_service_enable) {
        $rhnsd_service_enable_real = str2bool($rhnsd_service_enable)
      } else {
        $rhnsd_service_enable_real = $rhnsd_service_enable
      }
      validate_bool($rhnsd_service_enable_real)

      if is_string($up2date_settings_hiera_merge) {
        $up2date_settings_hiera_merge_real = str2bool($up2date_settings_hiera_merge)
      } else {
        $up2date_settings_hiera_merge_real = $up2date_settings_hiera_merge
      }
      validate_bool($up2date_settings_hiera_merge_real)

      if $up2date_settings_hiera_merge_real == true {
        $up2date_settings_real = hiera_hash('rhn::up2date_settings', $up2date_settings)
      } else {
        $up2date_settings_real = $up2date_settings
      }
      validate_hash($up2date_settings_real)

      validate_re($rhnsd_service_ensure, '^(running|stopped)$', 'rhn::rhnsd_service_ensure must be set to either running or stopped')
      validate_absolute_path($rhnsd_file_path)
      validate_absolute_path($up2date_file_path)

      package { $packages:
        ensure => 'installed',
      }

      $up2date_defaults = {
        'path'  => $up2date_file_path,
        require => Package[$packages],
      }
      create_ini_settings({ '' => $up2date_settings_real }, $up2date_defaults)

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
        enable  => $rhnsd_service_enable_real,
        name    => $rhnsd_service_name,
        require => Package[$packages],
      }
    }
    default: {
      notice("rhn is supported on osfamily RedHat. Your osfamily identified as ${::osfamily}.")
    }
  }
}
