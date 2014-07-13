class psp {
  package { "python-software-properties":
    provider    => 'apt',
    ensure      => 'present',
    require     => Exec['apt-get-update'],
  }
}