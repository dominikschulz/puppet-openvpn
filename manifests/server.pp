# == Define: openvpn::server
#
# This define creates the openvpn server instance and ssl certificates
#
#
# === Parameters
#
# [*country*]
#   String.  Country to be used for the SSL certificate
#
# [*province*]
#   String.  Province to be used for the SSL certificate
#
# [*city*]
#   String.  City to be used for the SSL certificate
#
# [*organization*]
#   String.  Organization to be used for the SSL certificate
#
# [*email*]
#   String.  Email address to be used for the SSL certificate
#
# [*common_name*]
#   String.  Common name to be used for the SSL certificate
#   Default: server
#
# [*compression*]
#   String.  Which compression algorithim to use
#   Default: comp-lzo
#   Options: comp-lzo or '' (disable compression)
#
# [*dev*]
#   String.  TUN/TAP virtual network device
#   Default: tun0
#   Options: tunX (routed connections), tapX (bridged connections). X
#   can be omitted for a dynamic device.
#
# [*user*]
#   String.  Group to drop privileges to after startup
#   Default: nobody
#
# [*group*]
#   String.  User to drop privileges to after startup
#   Default: depends on your $::osfamily
#
# [*ipp*]
#   Boolean.  Persist ifconfig information to a file to retain client IP
#     addresses between sessions
#   Default: false
#
# [*duplicate_cn*]
#   Boolean.  Allow multiple connections on one cn
#   Default: false
#
# [*local*]
#   String.  Interface for openvpn to bind to.
#   Default: $::ipaddress_eth0
#   Options: An IP address or '' to bind to all ip addresses
#
# [*logfile*]
#   String.  Logfile for this openvpn server
#   Default: false
#   Options: false (syslog) or log file name
#
# [*port*]
#   Integer.  The port the openvpn server service is running on
#   Default: 1194
#
# [*proto*]
#   String.  What IP protocol is being used.
#   Default: tcp
#   Options: tcp or udp
#
# [*status_log*]
#   String.  Logfile for periodic dumps of the vpn service status
#   Default: "${name}/openvpn-status.log"
#
# [*server*]
#   String.  Network to assign client addresses out of
#   Default: None.  Required in tun mode, not in tap mode
#
# [*server_ipv6*]
#   String.  IPv6 network to assign client addresses out of
#   Default: None.
#
# [*server_bridge*]
#   String. Server configuration to comply with existing DHCP server
#   Default: None.
#
# [*push*]
#   Array.  Options to push out to the client.  This can include routes, DNS
#     servers, DNS search domains, and many other options.
#   Default: []
#
# [*route*]
#   Array.  Add route to routing table after connection is established.
#     Multiple routes can be specified.
#   Default: []
#
# [*keepalive*]
#   String.  Add keepalive directive (ping and ping-restart) to server.
#     Should match the form "n m".
#   Default: None
#
# [*ssl_key_size*]
#   String. Length of SSL keys (in bits) generated by this module.
#   Default: 1024
#
# [*topology*]
#   String. Define the network topology type
#   Default: net30
#
# [*c2c*]
#   Boolean.  Enable client to client visibility
#   Default: false
#
# [*tcp-nodelay*]
#   Boolean, Enable/Disable.
#   Default: false
#
# [*ccd-exclusive*]
#   Boolean, Enable/Disable.
#   Default: false
#
# [*pam*]
#   Boolean, Enable/Disable.
#   Default: false
#
# [*management*]
#   Boolean.  Enable management interface
#   Default: false
#
# [*management_ip*]
#   String.  IP address where the management interface will listen
#   Default: localhost
#
# [*management_port*]
#   String.  Port where the management interface will listen
#   Default: 7505
#
# [*up*]
#   String,  Script which we want to run when openvpn server starts
#
# [*down*]
#   String,  Script which we want to run when openvpn server stops
#
# [*username_as_common_name*]
#   Boolean. If true then set username-as-common-name
#   Default: false
#
# [*client_cert_not_required*]
#   Boolean. If true then set client-cert-not-required
#   Default: false
#
# [*ldap_enabled*]
#   Boolean. If ldap is enabled, do stuff
#   Default: false
#
# [*ldap_server*]
#   String. URL of LDAP server. ie. ldap://URL:PORT
#   Default: None
#
# [*ldap_binddn*]
#   String. LDAP DN to bind as
#   Default: None
#
# [*ldap_bindpass*]
#   String. LDAP password for ldapbinddn
#   Default: None
#
# [*ldap_u_basedn*]
#   String. Place in the LDAP tree to look for users
#   Default: None
#
# [*ldap_u_filter*]
#   String. User SearchFilter for LDAP accounts
#   Default: None
#
# [*ldap_g_basedn*]
#   String. Place in the LDAP tree to look for groups
#   Default: None
#
# [*ldap_gmember*]
#   Boolean. If defined use group block in ldap.conf
#   Default: false
#
# [*ldap_g_filter*]
#   String. Group SearchFilter for LDAP accounts
#   Default: None
#
# [*ldap_memberatr*]
#   String. Attribute for MemberAttribute. Used with ldapfilter
#   Default: None
#
# [*ldap_tls_enable*]
#   Boolean. Enable TLS for the LDAP authentication
#   Default: false
#
# [*ldap_tls_ca_cert_file*]
#   String. LDAP TLS authentication: path to the CA certificate.
#   Default: None
#
# [*ldap_tls_ca_cert_dir*]
#   String. LDAP TLS authentication: path to the CA certificates.
#   Default: None
#
# [*ldap_tls_client_cert_file*]
#   String. LDAP TLS authentication: path to the tls client certificate
#   Default: None
#
# [*ldap_tls_client_key_file*]
#   String. LDAP TLS authentication: path to the tls client key
#   Default: None
#
# [*verb*]
#   Integer.  Level of logging verbosity
#   Default: 3
#
# [*cipher*]
#   String,  Cipher to use for packet encryption
#   Default: None
#
# [*persist_key*]
#   Boolean.  Try to retain access to resources that may be unavailable
#     because of privilege downgrades
#   Default: false
#
# [*persist_tun*]
#   Boolean.  Try to retain access to resources that may be unavailable
#     because of privilege downgrades
#   Default: false
#
# [*key_expire*]
#   String.  The number of days to certify the server certificate for
#   Default: 3650
#
# [*ca_expire*]
#   String.  The number of days to certify the CA certificate for
#   Default: 3650
#
# [*key_name*]
#   String.  Value for name_default variable in openssl.cnf (and KEY_NAME in vars)
#   Default: None
#
# [*key_ou*]
#   String.  Value for organizationalUnitName_default variable in openssl.cnf (and KEY_OU in vars)
#   Default: None
#
# [*key_cn*]
#   String.  Value for commonName_default variable in openssl.cnf (and KEY_CN in vars)
#   Default: None
#
# [*autostart*]
#   String.  Whether to add this server to the list of configurations to be automatically started on boot.
#   Default: true
#
# === Examples
#
#   openvpn::client {
#     'my_user':
#       server      => 'contractors',
#       remote_host => 'vpn.mycompany.com'
#    }
#
# * Removal:
#     Manual process right now, todo for the future
#
#
# === Authors
#
# * Raffael Schmid <mailto:raffael@yux.ch>
# * John Kinsella <mailto:jlkinsel@gmail.com>
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
# === License
#
# Copyright 2013 Raffael Schmid, <raffael@yux.ch>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
define openvpn::server(
  $country,
  $province,
  $city,
  $organization,
  $email,
  $common_name = 'server',
  $compression = 'comp-lzo',
  $dev = 'tun0',
  $user = 'nobody',
  $group = false,
  $ipp = false,
  $duplicate_cn = false,
  $local = $::ipaddress_eth0,
  $logfile = false,
  $port = '1194',
  $proto = 'tcp',
  $status_log = "${name}/openvpn-status.log",
  $server = '',
  $server_ipv6 = '',
  $server_bridge = '',
  $push = [],
  $route = [],
  $keepalive = '',
  $ssl_key_size = 1024,
  $topology = 'net30',
  $c2c = false,
  $tcp_nodelay = false,
  $ccd_exclusive = false,
  $pam = false,
  $management = false,
  $management_ip = 'localhost',
  $management_port = 7505,
  $up = '',
  $down = '',
  $username_as_common_name = false,
  $client_cert_not_required = false,
  $ldap_enabled = false,
  $ldap_server = '',
  $ldap_binddn = '',
  $ldap_bindpass = '',
  $ldap_u_basedn = '',
  $ldap_g_basedn = '',
  $ldap_gmember = false,
  $ldap_u_filter = '',
  $ldap_g_filter = '',
  $ldap_memberatr = '',
  $ldap_tls_enable = false,
  $ldap_tls_ca_cert_file = '',
  $ldap_tls_ca_cert_dir  = '',
  $ldap_tls_client_cert_file = '',
  $ldap_tls_client_key_file  = '',
  $ca_expire = 3650,
  $key_expire = 3650,
  $key_cn = '',
  $key_name = '',
  $key_ou = '',
  $verb = '',
  $cipher = '',
  $persist_key = false,
  $persist_tun = false,
  $autostart = true,
) {

  include openvpn
  Class['openvpn::install'] ->
  Openvpn::Server[$name] ~>
  Class['openvpn::service']

  $tls_server = $proto ? {
    /tcp/   => true,
    default => false
  }

  $group_to_set = $group ? {
    false   => $openvpn::params::group,
    default => $group
  }

  file {
    [ "/etc/openvpn/${name}",
      "/etc/openvpn/${name}/auth",
      "/etc/openvpn/${name}/client-configs",
      "/etc/openvpn/${name}/download-configs" ]:
        ensure  => directory;
  }

  exec {
    "copy easy-rsa to openvpn config folder ${name}":
      command => "/bin/cp -r ${openvpn::params::easyrsa_source} /etc/openvpn/${name}/easy-rsa",
      creates => "/etc/openvpn/${name}/easy-rsa",
      notify  => Exec["fix_easyrsa_file_permissions_${name}"],
      require => File["/etc/openvpn/${name}"];
  }

  exec {
    "fix_easyrsa_file_permissions_${name}":
      refreshonly => true,
      command     => "/bin/chmod 755 /etc/openvpn/${name}/easy-rsa/*";
  }

  file {
    "/etc/openvpn/${name}/easy-rsa/revoked":
      ensure  => directory,
      require => Exec["copy easy-rsa to openvpn config folder ${name}"];
  }

  file {
    "/etc/openvpn/${name}/easy-rsa/vars":
      ensure  => present,
      content => template('openvpn/vars.erb'),
      require => Exec["copy easy-rsa to openvpn config folder ${name}"];
  }

  file {
    "/etc/openvpn/${name}/easy-rsa/openssl.cnf":
      require => Exec["copy easy-rsa to openvpn config folder ${name}"];
  }

  if $openvpn::params::link_openssl_cnf == true {
    File["/etc/openvpn/${name}/easy-rsa/openssl.cnf"] {
      ensure => link,
      target => "/etc/openvpn/${name}/easy-rsa/openssl-1.0.0.cnf"
    }
  }

  exec {
    "generate dh param ${name}":
      command  => '. ./vars && ./clean-all && ./build-dh',
      cwd      => "/etc/openvpn/${name}/easy-rsa",
      creates  => "/etc/openvpn/${name}/easy-rsa/keys/dh${ssl_key_size}.pem",
      provider => 'shell',
      require  => File["/etc/openvpn/${name}/easy-rsa/vars"];

    "initca ${name}":
      command  => '. ./vars && ./pkitool --initca',
      cwd      => "/etc/openvpn/${name}/easy-rsa",
      creates  => "/etc/openvpn/${name}/easy-rsa/keys/ca.key",
      provider => 'shell',
      require  => [ Exec["generate dh param ${name}"],
                    File["/etc/openvpn/${name}/easy-rsa/openssl.cnf"] ];

    "generate server cert ${name}":
      command  => ". ./vars && ./pkitool --server ${common_name}",
      cwd      => "/etc/openvpn/${name}/easy-rsa",
      creates  => "/etc/openvpn/${name}/easy-rsa/keys/${common_name}.key",
      provider => 'shell',
      require  => Exec["initca ${name}"];
  }

  file {
    "/etc/openvpn/${name}/keys":
      ensure  => link,
      target  => "/etc/openvpn/${name}/easy-rsa/keys",
      require => Exec["copy easy-rsa to openvpn config folder ${name}"];
  }

  exec {
    "create crl.pem on ${name}":
      command  => ". ./vars && KEY_CN='' KEY_OU='' KEY_NAME='' KEY_ALTNAMES='' openssl ca -gencrl -out /etc/openvpn/${name}/crl.pem -config /etc/openvpn/${name}/easy-rsa/openssl.cnf",
      cwd      => "/etc/openvpn/${name}/easy-rsa",
      creates  => "/etc/openvpn/${name}/crl.pem",
      provider => 'shell',
      require  => Exec["generate server cert ${name}"];
  }

  file {
    "/etc/openvpn/${name}/easy-rsa/keys/crl.pem":
      ensure  => link,
      target  => "/etc/openvpn/${name}/crl.pem",
      require => Exec["create crl.pem on ${name}"];
  }

  if $::osfamily == 'Debian' and $autostart {
    openvpn::autostart { $name: }
  }

  file {
    "/etc/openvpn/${name}.conf":
      owner   => root,
      group   => root,
      mode    => '0444',
      content => template('openvpn/server.erb');
  }
  if $ldap_enabled == true {
    file {
      "/etc/openvpn/${name}/auth/ldap.conf":
        ensure  => present,
        content => template('openvpn/ldap.erb'),
        require => Package["openvpn-auth-ldap"],
    }
  }
}
