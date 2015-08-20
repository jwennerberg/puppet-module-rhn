Facter.add('rhnserverurl') do
  confine :osfamily => "RedHat"
  setcode do
    test_server = 'test -f /etc/sysconfig/rhn/up2date ; echo $?'
    if Facter::Util::Resolution.exec(test_server) == '0'
      cmd = 'grep ^serverURL= /etc/sysconfig/rhn/up2date 2>/dev/null | cut -f2 -d= 2>/dev/null'
      Facter::Util::Resolution.exec(cmd)
    end
  end
end
