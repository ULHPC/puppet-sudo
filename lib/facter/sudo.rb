Facter.add('sudoversion') do
  confine kernel: 'Linux'
  setcode do
    ENV['PATH'] = '/bin:/sbin:/usr/bin:/usr/sbin'
    output = `sudo -V 2>&1`
    if $?.exitstatus.zero?
      m = %r{Sudo version ([\d.]+)}.match output
      m[1] if m
    end
  end
end
