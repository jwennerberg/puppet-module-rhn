# puppet-module-rhn

[![Build Status](https://travis-ci.org/jwennerberg/puppet-module-rhn.png?branch=master)](https://travis-ci.org/jwennerberg/puppet-module-rhn)

Manages a client's Red Hat Network connection

## Compatibility
This module is built for use with Puppet v3 (or greater) on osfamily RedHat.

## Parameters

### `packages`
Packages to install

- *Default*: ['rhnsd','rhn-client-tools']

### `rhnsd_file_path`
hnsd sysconfig file's path

- *Default*: /etc/sysconfig/rhn/rhnsd

### `rhnsd_file_owner`
rhnsd sysconfig file's owner

- *Default*: root

### `rhnsd_file_group`
rhnsd sysconfig file's group

- *Default*: root

### `rhnsd_file_mode`
rhnsd sysconfig file's mode

- *Default*: 0644

### `rhnsd_interval`
Interval rhnsd checks against RHN (in minutes)

- *Default*: 240

### `rhnsd_service_ensure`
rhnsd service ensure value (running/stopped)

- *Default*: running

### `rhnsd_service_enable`
Enable the rhnsd service (true/false)

- *Default*: true

### `up2date_file_path`
up2date sysconfig file's path

- *Default*: /etc/sysconfig/rhn/up2date

### `up2date_settings`
Hash with up2date sysconfig settings

- *Default*: {}

### `up2date_settings_hiera_merge`
Boolean to control merges of all found instances of rhn::up2date_settings in Hiera.

- *Default*: true

## Hiera example
~~~puppet
rhn::rhnsd_interval: 300
rhn::up2date_settings:
  serverURL: 'https://satellite.example.com/XMLRPC'
  sslCACert: '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT'
~~~
