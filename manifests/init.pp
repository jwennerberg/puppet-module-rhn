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
  $up2date_file_path    = '/etc/sysconfig/rhn/up2date',
  $up2date_file_owner   = 'root',
  $up2date_file_group   = 'root',
  $up2date_file_mode    = '0600',
  $up2date_server_url   = 'http://xmlrpc.rhn.redhat.com/XMLRPC',
  $up2date_ssl_ca_cert  = '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT',
) {

  package { 'rhn_packages':
    ensure => 'installed',
    name   => $packages,
  }

  file { 'up2date_file':
    ensure  => 'file',
    path    => $up2date_file_path,
    owner   => $up2date_file_owner,
    group   => $up2date_file_group,
    mode    => $up2date_file_mode,
    content => template('rhn/up2date.erb'),
    require => Package['rhn_packages'],
  }

  file { 'rhnsd_file':
    ensure  => 'file',
    path    => $rhnsd_file_path,
    owner   => $rhnsd_file_owner,
    group   => $rhnsd_file_group,
    mode    => $rhnsd_file_mode,
    content => template('rhn/rhnsd.erb'),
    require => Package['rhn_packages'],
    notify  => Service['rhnsd_service'],
  }

  service { 'rhnsd_service':
    ensure  => $rhnsd_service_ensure,
    enable  => $rhnsd_service_enable,
    require => Package['rhn_packages'],
  }
}
