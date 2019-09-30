class bastion(
  Boolean       $fixperms_enable       = $bastion::params::fixperms_enable,
  Boolean       $fixperms_paranoia     = $bastion::params::fixperms_paranoia,
  Array[String] $fixperms_check_part   = $bastion::params::fixperms_check_part,
  Boolean       $fstab_enable          = $bastion::params::fstab_enable,
  Boolean       $fstab_set_nodev       = $bastion::params::fstab_set_nodev,
  Boolean       $fstab_set_nosuid      = $bastion::params::fstab_set_nosuid,
  Boolean       $fstab_fix_tmp         = $bastion::params::fstab_fix_tmp,
  Boolean       $fstab_fix_shm         = $bastion::params::fstab_fix_shm,
  Boolean       $sysctl_enable         = $bastion::params::sysctl_enable,
  Boolean       $sysctl_restrict_dmesg = $bastion::params::sysctl_restrict_dmesg,
  Boolean       $sysctl_net_hardening  = $bastion::params::sysctl_net_hardening,
  Boolean       $fix_ipmi_enable       = $bastion::params::fix_ipmi_enable,
  Boolean       $ipmi_lan_access_off   = $bastion::params::ipmi_lan_access_off,
) inherits bastion::params {
  if $fixperms_enable {
    include '::bastion::fixperms'
  }

  if $fstab_enable {
    include '::bastion::fstab'
  }

  if $sysctl_enable {
    include '::bastion::sysctl'
  }

  if $fix_ipmi_enable {
    include '::bastion::ipmi'
  }

}
