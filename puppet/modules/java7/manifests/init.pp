class java7 {
  $webupd8src = '/etc/apt/sources.list.d/webupd8team.list'
 
  file { $webupd8src:
    content => "deb http://ppa.launchpad.net/webupd8team/java/ubuntu lucid main\ndeb-src http://ppa.launchpad.net/webupd8team/java/ubuntu lucid main\n"
  } ->

  exec { 'add-webupd8-key':
    environment => 'HOME=/',
    command => '/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886',
    path => '/usr/bin:/bin',
    unless => 'apt-key list | grep -c EEA14886'
  } ->

  exec { 'apt-key-update':
    command => 'apt-key update',
    path => '/usr/bin:/bin',
    unless => 'apt-key list | grep -c EEA14886'
  } ->
  
  exec { 'java7-apt-get-update':
    command => 'apt-get update',
    path => '/usr/bin:/bin'
  } ->

  exec { 'java7-licence-agreement-1':
    command => 'sh -c "echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections"',
    path => '/usr/bin:/bin',
    unless => 'cat /etc/environment | grep -c java-7-oracle'
  } ->
  
  exec { 'java7-licence-agreement-2':
    command => 'sh -c "echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections"',
    path => '/usr/bin:/bin',
    unless => 'cat /etc/environment | grep -c java-7-oracle'
  } ->

  package {'oracle-java7-installer':
    provider  => 'apt',
    install_options => ['-y', '--force-yes']
  } ->
  
  exec { 'java7-home':
    command => 'sh -c "echo -e "\n\nJAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/environment;"',
    path => '/bin',
    unless => 'cat /etc/environment | grep -c java-7-oracle'
  }
}