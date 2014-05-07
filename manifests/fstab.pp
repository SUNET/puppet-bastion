class bastion::fstab {
  # Add nodev and nosuid mount option for non-root partitions
  if $bastion::fstab_set_nosuid {
    augeas{ "fstab-nosuid":
      context => "/files/etc/fstab/*[file != '/' and file != '/usr'][vfstype != 'swap' and vfstype != 'proc'][count(opt[. = 'nosuid']) = 0]",
      changes => [
                  "ins opt after opt[last()]",
                  "set opt[last()] nosuid"
                  ],
      onlyif  => "match /files/etc/fstab/*[file != '/' and file != '/usr'][vfstype != 'swap' and vfstype != 'proc'][count(opt[. = 'nosuid']) = 0] size > 0",
    }
  }
  
  if $bastion::fstab_set_nodev {
    augeas{ "fstab-nodev":
      context => "/files/etc/fstab/*[file != '/' and file != '/usr'][vfstype != 'swap' and vfstype != 'proc'][count(opt[. = 'nodev']) = 0]",
      changes => [
                  "ins opt after opt[last()]",
                  "set opt[last()] nodev"
                  ],
      onlyif  => "match /files/etc/fstab/*[file != '/' and file != '/usr'][vfstype != 'swap' and vfstype != 'proc'][count(opt[. = 'nodev']) = 0] size > 0",
    }
  }

  # Add tmpfs /tmp tmpfs size=512M,mode=1777,nosuid,nodev,noexec 0 0
  if $bastion::fstab_fix_tmp {
    augeas{ "fstab-fix-tmp":
      context => "/files/etc/fstab",
      changes => [
                  "set 01/spec tmpfs",
                  "set 01/file /tmp",
                  "set 01/vfstype tmpfs",
                  "set 01/opt[1] mode",
                  "set 01/opt[1]/value 1777",
                  "set 01/opt[2] nosuid",
                  "set 01/opt[3] nodev",
                  "set 01/opt[4] noexec",
                  "set 01/dump 0",
                  "set 01/passno 0"
                  ],
      onlyif  => "match *[file = '/tmp'] size == 0",
    }
  }

  # Add tmpfs     /dev/shm     tmpfs     defaults,noexec,nosuid     0     0
  if $bastion::fstab_fix_shm {
    augeas{ "fstab-fix-shm":
      context => "/files/etc/fstab",
      changes => [
                  "set 01/spec tmpfs",
                  "set 01/file /dev/shm",
                  "set 01/vfstype tmpfs",
                  "set 01/opt[1] defaults",
                  "set 01/opt[2] nosuid",
                  "set 01/opt[3] noexec",
                  "set 01/dump 0",
                  "set 01/passno 0"
                  ],
      onlyif  => "match /files/etc/fstab/*[file = '/dev/shm'] size == 0",
    }
  }

  define set_mountpoint_option($mount, $option) {
    augeas{ "fstab-$mount-$option":
      context => "/files/etc/fstab/*[file = '$mount'][count(opt[. = '$option']) = 0]",
      changes => [
                  "ins opt after opt[last()]",
                  "set opt[last()] $option"
                  ],
      onlyif  => "match /files/etc/fstab/*[file = '$mount'][count(opt[. = '$option']) = 0] size > 0",
    }
  }
}
