class bastion::params {
  $fixperms_enable       = true
  $fixperms_paranoia     = false
  $fixperms_check_part   = ["/"]
  $fstab_enable          = true
  $fstab_set_nodev       = true
  $fstab_set_nosuid      = true
  $fstab_fix_tmp         = true
  $fstab_fix_shm         = true
  $sysctl_enable         = true
  $sysctl_restrict_dmesg = true
  $sysctl_net_hardening  = true
  $rsyslog_enable        = false
  $fix_ipmi_enable       = false
  $ipmi_lan_access_off   = false
}
