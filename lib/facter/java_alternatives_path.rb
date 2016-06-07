
Facter.add('java_alternatives_path') do
  confine :kernel => 'Linux'
  setcode do
    if File.exist? '/var/lib/alternatives/java'
      file = File.open('/var/lib/alternatives/java', 'r')
      2.times{ file.gets }
      java_alternatives_path = $_.strip
    else
      java_alternatives_path = ""
    end
  end
end
