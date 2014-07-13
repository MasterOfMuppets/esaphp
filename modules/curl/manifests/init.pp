class curl {
  package { "curl":
    provider    => 'apt',
    ensure      => 'present',
    require     => Exec['apt-get-update'],
  }
}