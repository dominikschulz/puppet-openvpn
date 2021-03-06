# == Define: openvpn::client
#
# This define creates the client certs for a specified openvpn server as well
# as creating a tarball that can be directly imported into openvpn clients
#
#
# === Parameters
#
# [*server*]
#   String.  Name of the corresponding openvpn endpoint
#   Required
#
# [*compression*]
#   String.  Which compression algorithim to use
#   Default: comp-lzo
#   Options: comp-lzo or '' (disable compression)
#
# [*dev*]
#   String.  Device method
#   Default: tun
#   Options: tun (routed connections), tap (bridged connections)
#
# [*mute*]
#   Integer.  Set log mute level
#   Default: 20
#
# [*mute_replay_warnings*]
#   Boolean.  Silence duplicate packet warnings (common on wireless networks)
#   Default: true
#
# [*nobind*]
#   Boolean.  Whether or not to bind to a specific port number
#   Default: true
#
# [*persist_key*]
#   Boolean.  Try to retain access to resources that may be unavailable
#     because of privilege downgrades
#   Default: true
#
# [*persist_tun*]
#   Boolean.  Try to retain access to resources that may be unavailable
#     because of privilege downgrades
#   Default: true
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
# [*remote_host*]
#   String.  The IP or hostname of the openvpn server service
#   Default: FQDN
#
# [*cipher*]
#   String,  Cipher to use for packet encryption
#   Default: None
#
# [*resolv_retry*]
#   Integer/String. How many seconds should the openvpn client try to resolve
#     the server's hostname
#   Default: infinite
#   Options: Integer or infinite
#
# [*auth_retry*]
#   String. Controls how OpenVPN responds to username/password verification errors such
#     as the client-side response to an AUTH_FAILED message from the server or verification
#     failure of the private key password.
#   Default: none
#   Options: 'none' or 'nointeract' or 'interact'
#
# [*verb*]
#   Integer.  Level of logging verbosity
#   Default: 3
#
# [*pam*]
#   DEPRECATED: Boolean, Enable/Disable.
#
# [*authuserpass*]
#   Boolean. Set if username and password required
#   Default: false
#
# [*setenv*]
#   Hash. Set a custom environmental variable name=value to pass to script.
#   Default: {}
#
# [*setenv_safe*]
#   Hash. Set a custom environmental variable OPENVPN_name=value to pass to script.
#     This directive is designed to be pushed by the server to clients, and the prepending
#     of "OPENVPN_" to the environmental variable is a safety precaution to prevent a LD_PRELOAD
#     style attack from a malicious or compromised server.
#   Default: {}
#
# [*expire*]
#   Integer. Set a custom expiry time to pass to script.
#   Default: {}
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
define openvpn::client(
  $server,
  $compression = 'comp-lzo',
  $dev = 'tun',
  $mute = '20',
  $mute_replay_warnings = true,
  $nobind = true,
  $persist_key = true,
  $persist_tun = true,
  $port = '1194',
  $proto = 'tcp',
  $remote_host = $::fqdn,
  $resolv_retry = 'infinite',
  $auth_retry = 'none',
  $verb = '3',
  $pam = false,
  $cipher = '',
  $authuserpass = false,
  $setenv = {},
  $setenv_safe = {},
  $expire = undef,
  $up = undef,
  $down = undef,
  $readme = undef,
) {

  if $pam {
    warning('Using $pam is deprecated. Use $authuserpass instead!')
  }

  Openvpn::Server[$server] ->
  Openvpn::Client[$name]

  if $expire {
    $env_expire = "KEY_EXPIRE=${expire}"
  } else {
    $env_expire = ""
  }

  exec {
    "generate certificate for ${name} in context of ${server}":
      command     => ". ./vars && ${env_expire} ./pkitool ${name}",
      cwd         => "/etc/openvpn/${server}/easy-rsa",
      creates     => "/etc/openvpn/${server}/easy-rsa/keys/${name}.crt",
      provider    => 'shell';
  }

  file {
    [ "/etc/openvpn/${server}/download-configs/${name}",
      "/etc/openvpn/${server}/download-configs/${name}/keys"]:
        ensure  => directory;

    "/etc/openvpn/${server}/download-configs/${name}/keys/${name}.crt":
      ensure  => link,
      target  => "/etc/openvpn/${server}/easy-rsa/keys/${name}.crt",
      require => Exec["generate certificate for ${name} in context of ${server}"];

    "/etc/openvpn/${server}/download-configs/${name}/keys/${name}.key":
      ensure  => link,
      target  => "/etc/openvpn/${server}/easy-rsa/keys/${name}.key",
      require => Exec["generate certificate for ${name} in context of ${server}"];

    "/etc/openvpn/${server}/download-configs/${name}/keys/ca.crt":
      ensure  => link,
      target  => "/etc/openvpn/${server}/easy-rsa/keys/ca.crt",
      require => Exec["generate certificate for ${name} in context of ${server}"];

    "/etc/openvpn/${server}/download-configs/${name}/keys/tls-auth.key":
      ensure  => link,
      target  => "/etc/openvpn/${server}/easy-rsa/keys/tls-auth.key",
      require => Exec["generate certificate for ${name} in context of ${server}"];

    "/etc/openvpn/${server}/download-configs/${name}/${name}.conf":
      owner   => root,
      group   => root,
      mode    => '0444',
      content => template('openvpn/client.erb'),
      notify  => Exec["generate ${name}.ovpn in ${server}"];
  }

  if $readme {
    file {
      "/etc/openvpn/${server}/download-configs/${name}/README":
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0444',
        content => $readme,
        notify  => Exec["tar the thing ${server} with ${name}"];
    }
  }

  $name_escaped = regsubst(regsubst($name, '\.', '\\.', 'G'), '@', '\\@', 'G')
  exec {
    "generate ${name}.ovpn in ${server}":
      cwd         => "/etc/openvpn/${server}/download-configs/",
      command     => "/bin/rm ${name}.ovpn; cat ${name}/${name}.conf|perl -lne 'if(m|^ca keys/ca.crt|){ chomp(\$ca=`cat ${name_escaped}/keys/ca.crt`); print \"<ca>\n\$ca\n</ca>\"} elsif(m|^cert keys/${name_escaped}.crt|) { chomp(\$crt=`cat ${name_escaped}/keys/${name_escaped}.crt`); print \"<cert>\n\$crt\n</cert>\"} elsif(m|^key keys/${name_escaped}.key|){ chomp(\$key=`cat ${name_escaped}/keys/${name_escaped}.key`); print \"<key>\n\$key\n</key>\"} elsif(m|^(tls-auth) (keys/tls-auth.key)( .+)?|){ chomp(\$tlsauth=`cat ${name_escaped}/keys/tls-auth.key`); print \"<tls-auth>\n\$tlsauth\n</tls-auth>\nkey-direction 1\"} elsif(m/^(up|down) /){ next; } else { print} ' > ${name}.ovpn",
      refreshonly => true,
      require     => [  File["/etc/openvpn/${server}/download-configs/${name}/${name}.conf"],
                        File["/etc/openvpn/${server}/download-configs/${name}/keys/ca.crt"],
                        File["/etc/openvpn/${server}/download-configs/${name}/keys/${name}.key"],
                        File["/etc/openvpn/${server}/download-configs/${name}/keys/${name}.crt"],
                      ],
  }

  file { "/etc/openvpn/${server}/download-configs/${name}.ovpn":
    mode    => '0400',
    require => Exec["generate ${name}.ovpn in ${server}"],
    notify  => Exec["tar the thing ${server} with ${name}"],
  }

  file {
    "/etc/openvpn/${server}/download-configs/${name}.tblk":
      ensure  => directory;

    "/etc/openvpn/${server}/download-configs/${name}.tblk/${name}.ovpn":
      ensure  => link,
      target  => "/etc/openvpn/${server}/download-configs/${name}.ovpn",
      require => [  Exec["generate ${name}.ovpn in ${server}"],
                    File["/etc/openvpn/${server}/download-configs/${name}.tblk"]
                 ];
  }

  exec {
    "tar the thing ${server} with ${name}":
      cwd         => "/etc/openvpn/${server}/download-configs/",
      command     => "/bin/rm ${name}.tar.gz; tar --exclude=\\*.conf.d -chzvf ${name}.tar.gz ${name} ${name}.tblk",
      refreshonly => true,
      require     => [  File["/etc/openvpn/${server}/download-configs/${name}/${name}.conf"],
                        File["/etc/openvpn/${server}/download-configs/${name}/keys/ca.crt"],
                        File["/etc/openvpn/${server}/download-configs/${name}/keys/${name}.key"],
                        File["/etc/openvpn/${server}/download-configs/${name}/keys/${name}.crt"],
                        File["/etc/openvpn/${server}/download-configs/${name}.ovpn"],
                        File["/etc/openvpn/${server}/download-configs/${name}.tblk"],
                        File["/etc/openvpn/${server}/download-configs/${name}.tblk/${name}.ovpn"],
                      ],
  }

}
