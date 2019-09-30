class bastion::fixperms {
  $fixperms_paranoia = $bastion::fixperms_paranoia
  $fixperms_check_part = $bastion::fixperms_check_part

  $script = '/etc/cron.daily/fixperms.sh'

  file { $script:
    content => template('bastion/fixperms/fixperms.sh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
  }

  exec { $script:
    refreshonly => true,
    require     => File[$script],
    subscribe   => File[$script],
  }
}
