# == Class: tor
#
# This class handles installing the Tor onion router.
# https://www.torproject.org/
# Default configuration is to be a tor client.
#
# === Parameters:
#
# [*socksport*]
#   Open this port to listen for connections from SOCKS-speaking applications.
#   Default: 127.0.0.1:9050
#
# [*sockspolicy*]
#   Set an entrance policy for this server, to limit who can connect to the
#   SocksPort.
#   Default: accept *:*
#
# [*orport*]
#   Advertise this port to listen for connections from Tor clients and servers.
#   This option is required to be a Tor server.
#   Default: 0
#
# [*address*]
#   The IP address or fully qualified domain name of this server. You can leave
#   this unset, and Tor will guess your IP address. This IP address is the one
#   used to tell clients and other servers where to find your Tor server; it
#   doesn’t affect the IP that your Tor client binds to.
#   Default: none
#
# [*outboundbindaddress*]
#   Make all outbound connections originate from the IP address specified. This
#   is only useful when you have multiple network interfaces, and you want all
#   of Tor’s outgoing connections to use a single one.
#   Default: none
#
# [*nickname*]
#   Set the server’s nickname to 'name'. Nicknames must be between 1 and 19
#   characters inclusive, and must contain only the characters [a-zA-Z0-9].
#   Default: none
#
# [*myfamily*]
#   Declare that this Tor server is controlled or administered by a group or
#   organization identical or similar to that of the other servers, defined by
#   their identity fingerprints or nicknames.
#   Default: none
#
# [*bandwidthrate*]
#   A token bucket limits the average incoming bandwidth usage on this node to
#   the specified number of bytes per second, and the average outgoing
#   bandwidth usage to that same value.
#   Default: 5 MB
#
# [*bandwidthburst*]
#   Limit the maximum token bucket size (also known as the burst) to the given
#   number of bytes in each direction.
#   Default: 10 MB
#
# [*numcpus*]
#   How many processes to use at once for decrypting onionskins and other
#   parallelizable operations.
#   Default: 0 (autodetect)
#
# [*contactinfo*]
#   Administrative contact information for server.
#   Default: none
#
# [*dirport*]
#   If this option is nonzero, advertise the directory service on this port.
#   Default: 0
#
# [*exitpolicy*]
#   Set an exit policy for this server.
#   Default: reject *:25,reject *:119,reject *:135-139,reject *:445,
#            reject *:563,reject *:1214,reject *:4661-4666,reject *:6346-6429,
#            reject *:6699,reject *:6881-6999,accept *:*
#
# [*dnsport*]
#   If non-zero, open this port to listen for UDP DNS requests, and
#   resolve them anonymously.
#   Default: none
#
# [*transport*]
#   Open this port to listen for transparent proxy connections. This
#   directive can be specified multiple times to bind to multiple
#   addresses/ports. If you’re planning to use Tor as a transparent
#   proxy for a network, you’ll want to examine and change
#   VirtualAddrNetwork from the default setting.
#   Default: none
#
# [*virtualaddrnetwork*]
#   When Tor needs to assign a virtual (unused) address because of a
#   MAPADDRESS command from the controller or the AutomapHostsOnResolve
#   feature, Tor picks an unassigned address from this range.
#   When providing proxy server service to a network of computers using
#   a tool like dns-proxy-tor, change the IPv4 network to
#   "10.192.0.0/10" or "172.16.0.0/12". The default VirtualAddrNetwork
#   address ranges on a properly configured machine will route to the
#   loopback or link-local interface. For local use, no change to the
#   default VirtualAddrNetwork setting is needed.
#   Default: 127.192.0.0/10
#
# [*virtualaddrnetwork6*]
#   When providing proxy server service to a network of computers using
#   a tool like dns-proxy-tor, change the IPv6 network to
#   "[fe80::]/10".
#   Default: [fe80::]/10
#
# [*automaphosts*]
#   When this option is enabled, and we get a request to resolve an
#   address that ends with one of the suffixes in AutomapHostsSuffixes,
#   we map an unused virtual address to that address, and return the
#   new virtual address. This is handy for making ".onion" addresses
#   work with applications that resolve an address and then connect to it.
#   Default: false (0)
#
# [*yum_server*]
#   The URL for the YUM server host.
#   Default: http://deb.torproject.org
#
# [*yum_path*]
#   The URL path.
#   Default: /torproject.org/rpm
#
# [*yum_priority*]
#   The priority that the Tor YUM repos will have.
#   Default: 50
#
# [*yum_protect*]
#   Whether to protect this YUM repo.
#   Default: 0
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*autoupgrade*]
#   Upgrade package automatically, if there is a newer version.
#   Default: false
#
# [*package_name*]
#   Name of the package.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*file_name*]
#   Name of the client config file.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*service_ensure*]
#   Ensure if service is running or stopped.
#   Default: running
#
# [*service_name*]
#   Name of the service
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*service_enable*]
#   Start service at boot.
#   Default: false
#
# [*service_hasrestart*]
#   Service has restart command.
#   Default: true
#
# [*service_hasstatus*]
#   Service has status command.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: true
#
# === Actions:
#
# Installs the tor package.
# Manages the torrc file.
# Starts the tor service.
#
# === Sample Usage:
#
#  # default client
#  class { 'tor': }
#
#  # relay only
#  class { 'tor':
#    socksport           => [ '0' ],
#    sockspolicy         => [ 'reject *' ],
#    orport              => [ '443 NoListen', '10.2.3.4:9090 NoAdvertise' ],
#    address             => '10.2.3.4',
#    outboundbindaddress => '10.2.3.4',
#    nickname            => 'ididnteditheconfig',
#    myfamily            => '10.2.3.5',
#    bandwidthrate       => '100 MB',
#    bandwidthburst      => '200 MB',
#    numcpus             => '2',
#    contactinfo         => 'Random Person <nobody AT example dot com>',
#    dirport             => [ '80 NoListen', '10.2.3.4:9091 NoAdvertise' ],
#    exitpolicy          => [ 'reject *:*' ],
#  }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class tor (
  $socksport           = $tor::params::socksport,
  $sockspolicy         = $tor::params::sockspolicy,
  $orport              = $tor::params::orport,
  $address             = $tor::params::address,
  $outboundbindaddress = $tor::params::outboundbindaddress,
  $nickname            = $tor::params::nickname,
  $myfamily            = $tor::params::myfamily,
  $bandwidthrate       = $tor::params::bandwidthrate,
  $bandwidthburst      = $tor::params::bandwidthburst,
  $numcpus             = $tor::params::numcpus,
  $contactinfo         = $tor::params::contactinfo,
  $dirport             = $tor::params::dirport,
  $exitpolicy          = $tor::params::exitpolicy,
  $dnsport             = $tor::params::dnsport,
  $transport           = $tor::params::transport,
  $virtualaddrnetwork  = $tor::params::virtualaddrnetwork,
  $virtualaddrnetwork6 = $tor::params::virtualaddrnetwork6,
  $automaphosts        = $tor::params::automaphosts,

  $yum_server          = $tor::params::yum_server,
  $yum_path            = $tor::params::yum_path,
  $yum_priority        = $tor::params::yum_priority,
  $yum_protect         = $tor::params::yum_protect,

  $ensure              = $tor::params::ensure,
  $autoupgrade         = $tor::params::safe_autoupgrade,
  $package_name        = $tor::params::package_name,
  $file_name           = $tor::params::file_name,
  $service_ensure      = $tor::params::service_ensure,
  $service_name        = $tor::params::service_name,
  $service_enable      = $tor::params::safe_service_enable,
  $service_hasrestart  = $tor::params::safe_service_hasrestart,
  $service_hasstatus   = $tor::params::service_hasstatus
) inherits tor::params {
  # Validate our booleans
  validate_bool($autoupgrade)
  validate_bool($service_enable)
  validate_bool($service_hasrestart)
  validate_bool($service_hasstatus)

  case $ensure {
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }

      if $service_ensure in [ running, stopped ] {
        $service_ensure_real = $service_ensure
        $service_enable_real = $service_enable
      } else {
        fail('service_ensure parameter must be running or stopped')
      }
      $file_ensure = 'present'
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $service_ensure_real = 'stopped'
      $service_enable_real = false
      $file_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  Class['tor::yum'] -> Class['tor']

  class { 'tor::yum' :
    yum_server   => $yum_server,
    yum_path     => $yum_path,
    yum_priority => $yum_priority,
    yum_protect  => $yum_protect,
  }

  package { $package_name :
    ensure => $package_ensure,
  }

  file { $file_name :
    ensure  => $file_ensure,
    mode    => '0644',
    owner   => 'root',
    group   => '_tor',
    content => template('tor/torrc.erb'),
    require => Package[$package_name],
    notify  => Service[$service_name],
  }

  service { $service_name :
    ensure     => $service_ensure_real,
    enable     => $service_enable_real,
    hasrestart => $service_hasrestart,
    hasstatus  => $service_hasstatus,
    require    => Package[$package_name],
  }
}
