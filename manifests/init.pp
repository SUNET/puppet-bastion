class bastion(
  $fixperms_enable       = $bastion::params::fixperms_enable,
  $fixperms_paranoia     = $bastion::params::fixperms_paranoia,
  $fixperms_check_part   = $bastion::params::fixperms_check_part,
  $fstab_enable          = $bastion::params::fstab_enable,
  $fstab_set_nodev       = $bastion::params::fstab_set_nodev,
  $fstab_set_nosuid      = $bastion::params::fstab_set_nosuid,
  $fstab_fix_tmp         = $bastion::params::fstab_fix_tmp,
  $fstab_fix_shm         = $bastion::params::fstab_fix_shm,
  $sysctl_enable         = $bastion::params::sysctl_enable,
  $sysctl_restrict_dmesg = $bastion::params::sysctl_restrict_dmesg,
  $sysctl_net_hardening  = $bastion::params::sysctl_net_hardening,
  ) inherits bastion::params {
  
  validate_bool($fixperms_enable)
  validate_bool($fixperms_paranoia)
  validate_array($fixperms_check_part)
  validate_bool($fstab_enable)
  validate_bool($fstab_fix_tmp)
  validate_bool($fstab_fix_shm)
  validate_bool($fstab_set_nodev)
  validate_bool($fstab_set_nosuid)
  validate_bool($sysctl_enable)
  validate_bool($sysctl_restrict_dmesg)
  validate_bool($sysctl_net_hardening)

  if $fixperms_enable {
    include '::bastion::fixperms'
  }

  if $fstab_enable {
    include '::bastion::fstab'
  }

  if $sysctl_enable {
    include '::bastion::sysctl'
  }

}
