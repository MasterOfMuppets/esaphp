# set defaults for file ownership/permissions
File {
  owner => 'root',
  group => 'root',
  mode  => '0644',
}


exec { "apt-get-update" :
  command     => "/usr/bin/apt-get update"
}

class { 'elasticsearch': 
  package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.deb',
  config                   => {
     'node'                 => {
       'name'               => 'elasticMuppet'
     },
     'index'                => {
       'number_of_replicas' => '0',
       'number_of_shards'   => '5'
     }
  }
}

class { 'puppi':
  install_dependencies => false,
}

class { 'apache':
    mpm_module => 'prefork',
}


apache::vhost { 'test.elasticon.es':
  port    => '80',
  docroot => '/vagrant/web'
}

class { 'php': 
    service => 'apache2'
}

php::module { "cli": }
php::module { "curl": }

class { 'composer':
    target_dir      => '/usr/local/bin',
    composer_file   => 'composer', # could also be 'composer.phar'
    download_method => 'curl',     # or 'wget'
    logoutput       => true,
    tmp_path        => '/tmp',
    php_package     => 'php5-cli',
    curl_package    => 'curl',
    wget_package    => 'wget',
    composer_home   => '/home/vagrant/.composer',
    php_bin         => 'php', # could also i.e. be 'php -d "apc.enable_cli=0"' for more fine grained control
    suhosin_enabled => false
}

Exec['apt-get-update'] -> Class['puppi'] -> Class['apache']

Class['java7'] -> Class['elasticsearch']

Class['php'] -> Class['git'] -> Class['composer']

include puppi
include php
include stdlib
include apt
include apache
include ::apache::mod::php
include java7
include elasticsearch
include git
include composer