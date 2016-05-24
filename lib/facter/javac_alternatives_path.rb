
Facter.add('javac_alternatives_path') do
  confine :kernel => 'Linux'
  setcode do
    if File.exist? '/var/lib/alternatives/javac'
      file = File.open('/var/lib/alternatives/javac', 'r')
      2.times{ file.gets }
      javac_alternatives_path = $_.strip
    end
  end
end
