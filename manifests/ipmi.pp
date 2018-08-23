class bastion::ipmi {
    if $::is_virtual == false {
        package { 'ipmitool': } ->
        exec { 'modprobe ipmi_devintf; modprobe ipmi_si':
            unless => 'ipmitool lan print &> /dev/null'
        } ->

        if $bastion::ipmi_lan_access_off {
            exec { 'ipmitool lan set 1 access off':
                unless => 'ipmitool channel info 1 | egrep -o "[[:space:]]+Access[[:space:]]Mode[[:space:]]+:[[:space:]]disabled"'
            }
        }
    }
}
