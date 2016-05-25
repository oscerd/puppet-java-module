
Facter.add('javaws_alternatives_path') do
  confine :kernel => 'Linux'
  setcode do
    if File.exist? '/var/lib/alternatives/javaws'
      file = File.open('/var/lib/alternatives/javaws', 'r')
      2.times{ file.gets }
      javaws_alternatives_path = $_.strip
    end
  end
end
