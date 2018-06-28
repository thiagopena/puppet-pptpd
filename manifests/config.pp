# pptpd::config class
#
# Manage the server config
#
class pptpd::config {

  $ensure = $pptpd::package_ensure ? {
    'absent' => 'absent',
    'purged' => 'absent',
    default  => 'present'
  }

  file { '/etc/pptpd.conf':
    ensure  => $ensure,
    owner   => 'root',
    mode    => '0644',
    content => template('pptpd/pptpd.conf.erb')
  }

  $options_array = lookup(
    'pptpd::options',
    Array[String],
    'unique',
    []
  )

  file { $pptpd::options_file:
    ensure  => $ensure,
    owner   => 'root',
    mode    => '0644',
    content => epp('pptpd/pptpd-options.epp', {
      server_name => $pptpd::server_name,
      dns_servers => $pptpd::dns_servers,
      options     => $pptpd::config::options_array,
    }),
  }
}