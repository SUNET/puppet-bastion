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

        # ipmiutil is only available on Ubuntu > 14.04
        if $::operatingsystem == 'Ubuntu' and $::operatingsystemrelease != '14.04' and $::operatingsystemrelease != '12.04' {
            package { 'ipmiutil': } ->
            exec { 'ipmiutil lan -d':
                unless => 'bash -c \'ipmi_lan_print="$(ipmitool lan print)" && echo "${ipmi_lan_print}" | egrep -o "IP Address Source[[:space:]]+: Static Address" && echo "${ipmi_lan_print}" | egrep -o "IP Address[[:space:]]+: 0.0.0.0" && echo "${ipmi_lan_print}" | egrep -o "Subnet Mask[[:space:]]+: 0.0.0.0" && echo "${ipmi_lan_print}" | egrep -o "Default Gateway IP[[:space:]]+: 0.0.0.0"\''
            }
        }
    }
}
