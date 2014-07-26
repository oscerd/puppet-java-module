define java::setup (
  $type = undef,
  $family = undef,
  $update_version = undef,
  $architecture = undef,
  $os = undef,
  $extension = undef,
  $tmpdir = undef,
  ) { 
    
  # Validate parameters
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
  
  if ($tmpdir == undef){
    notify{'Temp folder not specified, setting default install folder /tmp/':}
    $defined_tmpdir ='/tmp/'
  } else {
    $defined_tmpdir = $tmpdir
  }
  
  file { "${defined_tmpdir}${type}-${family}u${update_version}-${os}-${architecture}${extension}":
      ensure => present,
      source => "puppet:///modules/java/${type}-${family}u${update_version}-${os}-${architecture}${extension}" }

  exec { 'extract_java': 
          command => "unzip ${defined_tmpdir}${type}-${family}u${update_version}-${os}-${architecture}${extension}",
          require => [ File[ "${defined_tmpdir}${type}-${family}u${update_version}-${os}-${architecture}${extension}"], 
                       Package[unzip] ] }
  }