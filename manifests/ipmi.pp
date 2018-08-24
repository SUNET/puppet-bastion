class bastion::ipmi {
    if $::is_virtual == false {
        package { 'ipmitool': } ->
        exec { 'modprobe ipmi_devintf; modprobe ipmi_si':
            unless => 'ipmitool lan print &> /dev/null'
        } ->

        if $bastion::ipmi_lan_access_off {
            exec { 'ipmitool lan set 1 access off':
                unless => 'ipmitool channel info 1 | egrep -o "[[:space:]]+Access Mode[[:space:]]+: disabled"'
            }
        }

        # Disable NONE etc authentication by only allowing MD5
        exec { 'ipmitool lan set 1 auth Callback MD5; ipmitool lan set 1 auth User MD5; ipmitool lan set 1 auth Operator MD5; ipmitool lan set 1 auth Admin MD5; ipmitool lan set 1 auth OEM MD5':
            onlyif => 'ipmitool lan print | egrep "NONE|MD2|PASSWORD"'
        }

        # Disable IPMI access for all common, default users
        exec { 'bash -c \'if [[ -n "$(ipmitool user summary 1 | egrep -o "Enabled User Count[[:space:]]+: [1-9]+")" ]]; then admin_user="$(ipmitool user list 1 | egrep "[1-9]+[[:space:]]+ADMIN|root|admin|Administrator|USERID" | egrep -o "^[0-9]+")"; ipmitool user disable "${admin_user}"; fi\'': }

        # ipmiutil lan -d "disables the IPMI LAN and PEF parameters,
        # so as not to allow BMC LAN connections or alerts.
        # This option  also  sets the IP address to zeros."
        # However ipmiutil is only available on Ubuntu > 14.04
        if $::operatingsystem == 'Ubuntu' and $::operatingsystemrelease != '14.04' and $::operatingsystemrelease != '12.04' {
            package { 'ipmiutil': } ->
            exec { 'ipmiutil lan -d':
                unless => 'bash -c \'ipmi_lan_print="$(ipmitool lan print)" && echo "${ipmi_lan_print}" | egrep -o "IP Address Source[[:space:]]+: Static Address" && echo "${ipmi_lan_print}" | egrep -o "IP Address[[:space:]]+: 0.0.0.0" && echo "${ipmi_lan_print}" | egrep -o "Subnet Mask[[:space:]]+: 0.0.0.0" && echo "${ipmi_lan_print}" | egrep -o "Default Gateway IP[[:space:]]+: 0.0.0.0"\''
            }
        }
    }
}
