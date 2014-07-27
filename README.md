Puppet Java Module
========================

## <a name='TOC'>Table of Contents</a>

  1. [Introduction](#Introduction)
  1. [Installation](#Installation)
  1. [Usage](#Usage)
  1. [Contributing](#Contributing)

## <a name='Introduction'>Introduction</a>

This module install JDK or JRE with puppet

## <a name='Installation'>Installation</a>

Clone this repository in a java directory in your puppet module directory

	git clone https://github.com/ancosen/puppet-java-module java

## <a name='Usage'>Usage</a>

If you include the java::setup class the module will take the package from '/java/files' folder, extract his content it and move it 
in a specific directory (based on the OS we are working on). Here is an example:

	java::setup { "java":
	  type => "jdk",
	  family => "7",
	  update_version => "65",
	  architecture => "x64",
	  os => "linux",
	  extension => ".tar.gz",
	  tmpdir => ""
	  }

It's important to define a global search path for the `exec` resource to make module work. 
This should usually be placed in `manifests/site.pp`:

	Exec {
	  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	}

## <a name='Contributing'>Contributing</a>

Feel free to contribute by testing, opening issues and adding/changing code
