class bastion::sysctl {
  if $bastion::sysctl_restrict_dmesg {
    file { '/etc/sysctl.d/20-bastion-restrict-dmesg.conf':
      content => "kernel.dmesg_restrict = 1\n",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
    exec { '/sbin/sysctl -p /etc/sysctl.d/20-bastion-restrict-dmesg.conf':
      subscribe   => File['/etc/sysctl.d/20-bastion-restrict-dmesg.conf'],
      refreshonly => true
    }
  }

  if $bastion::sysctl_net_hardening {
    file { '/etc/sysctl.d/20-bastion-network-hardening.conf':
      content => template('bastion/sysctl/sysctl-network-hardening.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    exec { '/sbin/sysctl -p /etc/sysctl.d/20-bastion-network-hardening.conf':
      subscribe   => File['/etc/sysctl.d/20-bastion-network-hardening.conf'],
      refreshonly => true
    }
  }
}
