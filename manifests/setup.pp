define java::setup (
  $type = undef,
  $family = undef,
  $update_version = undef,
  $architecture = undef,
  $os = undef,
  $extension = undef,
  $tmpdir = undef,
  ) { 
    
  # Validate parameters presence 
  if ($type == undef) {
    fail('type parameter must be set')
  }
  
  if ($family == undef) {
    fail('family parameter must be set')
  }
  
  if ($update_version == undef) {
    fail('update version parameter must be set')
  }
  
  if ($architecture == undef) {
    fail('architecture parameter must be set')
  }
  
  if ($os == undef) {
    fail('Operating system parameter must be set')
  }
  
  $java_home_base = $operatingsystem ? {
    /(?i:SLES|OpenSuSE)/ => '/usr/lib/java',
    /(?i:Ubuntu|Debian|Mint|Centos)/ => '/usr/lib/jvm',
    default => '/usr/lib/jvm',
  }
  
  if ($tmpdir == undef){
    notify{'Temp folder not specified, setting default install folder /tmp/':}
    $defined_tmpdir ='/tmp/'
  } else {
    $defined_tmpdir = $tmpdir
  }
  
  package { 'tar':
			      ensure => installed,
			      alias => tar   }
  
  file { "${defined_tmpdir}${type}-${family}u${update_version}-${os}-${architecture}${extension}":
		      ensure => present,
		      source => "puppet:///modules/java/${type}-${family}u${update_version}-${os}-${architecture}${extension}" }

  exec { 'extract_java': 
          command => "tar -xzvf ${defined_tmpdir}${type}-${family}u${update_version}-${os}-${architecture}${extension} -C ${defined_tmpdir}",
          require => [ File[ "${defined_tmpdir}${type}-${family}u${update_version}-${os}-${architecture}${extension}"], 
                       Package[tar] ], 
          alias => extract }
                       
  file { "$java_home_base":
		      ensure => directory,
		      mode => '755',
		      owner => 'root', 
		      alias => java_home }
  
  exec { 'move_java': 
          command => "mv ${defined_tmpdir}${type}1.${family}.0_${update_version}/ ${java_home_base}",
          require => [ File[ java_home ], 
                       Exec[ extract ] ] }
                       
  exec { 'install_java':
          require => Exec ['move_java'],
          logoutput => true,
          command => "update-alternatives --install /bin/java java ${java_home_base}/${type}1.${family}.0_${update_version}/bin/java 1"  }

  exec { 'set_java':
          require => Exec ['install_java'],
          logoutput => true,
          command => "update-alternatives --set java ${java_home_base}/${type}1.${family}.0_${update_version}/bin/java"  } 
          
  exec { 'install_javac':
          require => Exec ['move_java'],
          logoutput => true,
          command => "update-alternatives --install /bin/javac javac ${java_home_base}/${type}1.${family}.0_${update_version}/bin/javac 1"  }

  exec { 'set_javac':
          require => Exec ['install_javac'],
          logoutput => true,
          command => "update-alternatives --set javac ${java_home_base}/${type}1.${family}.0_${update_version}/bin/javac"  } 
          
  exec { 'install_javaws':
          require => Exec ['move_java'],
          logoutput => true,
          command => "update-alternatives --install /bin/javaws javaws ${java_home_base}/${type}1.${family}.0_${update_version}/bin/javaws 1"  }

  exec { 'set_javaws':
          require => Exec ['install_javaws'],
          logoutput => true,
          command => "update-alternatives --set javaws ${java_home_base}/${type}1.${family}.0_${update_version}/bin/javaws"  } 
  }