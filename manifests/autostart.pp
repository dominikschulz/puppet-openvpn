# == Define: openvpn::autostart
define openvpn::autostart(
  $ensure = 'present',
) {
  concat::fragment {
    "openvpn.default.autostart.${name}":
      ensure  => $ensure,
      content => "AUTOSTART=\"\$AUTOSTART ${name}\"\n",
      target  => '/etc/default/openvpn',
      order   => 10;
  }
}
