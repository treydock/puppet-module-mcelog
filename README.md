# puppet-module-mcelog

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/mcelog.svg)](https://forge.puppetlabs.com/treydock/mcelog)
[![CI Status](https://github.com/treydock/puppet-module-mcelog/workflows/CI/badge.svg?branch=master)](https://github.com/treydock/puppet-module-mcelog/actions?query=workflow%3ACI)

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
    * [Public Classes](#public-classes)
    * [Public Defines](#public-defines)
4. [Compatibility](#compatibility)
5. [Development - Guide for contributing to the module](#development)

## Overview

This is a puppet module for the installation and configuration of the
[`mcelog`](http://www.mcelog.org/) utility.  Which can be used either from the
cli or run as a daemon that extracts and decodes [Machine Check Exception
(MCE)](https://en.wikipedia.org/wiki/Machine-check_exception) data.

## Usage

To install `mcelog` and start service.

```puppet
include ::mcelog
```

Example of configuring `mcelog.conf` via `settings` Hash.

```puppet
class { '::mcelog':
  settings => {
    ''  => {
      'filter' => 'yes',
    },
    'server' => {
      'client-user' => 'root',
    },
  },
}
```

Example of what Hiera data would look like for settings:

```yaml
mcelog::settings:
  '':
    filter: 'yes'
  server:
    client-user: 'root'
```

## Reference

[http://treydock.github.io/puppet-module-mcelog/](http://treydock.github.io/puppet-module-mcelog/)

## Compatibility

Tested using

* CentOS 6
* CentOS 7
