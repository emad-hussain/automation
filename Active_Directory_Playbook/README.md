# This Ansible playbook automates the process of joining a Linux machine to an Active Directory (AD).The playbook performs the following tasks:

1. Verify whether the AD has already been connected to the server using the `realm list` command and store the output in a variable named "realm_list_output".
2. Disconnect from AD if already connected using the `realm leave` command when `realm_list_output` is not empty.
3. Install the required packages using `yum` when `realm_list_output` is empty. The required packages are "sssd, realmd, oddjob, oddjob-mkhomedir, adcli, samba-common, samba-common-tools, krb5-workstation, openldap-clients, and policycoreutils-python".
4. Copy the EPEL RPM package from "/tmp/epel-release-latest-7.noarch.rpm" to "/tmp/epel-release-latest-7.noarch.rpm" and install it using yum.
5. Install python-pip using yum.
6. Upgrade the version of the pexpect module to v3.3 using pip.
7. Configure the nameserver and search domain in "/etc/resolv.conf".
8. Join the linux machine to the AD domain using the `realm join` command when `realm_list_output` is empty. The username and domain name are passed as parameters to the `realm join` command, and the user is prompted to enter their AD password at the beginning, and store it in "domain_pass" variable, the stored output is now passed the "expect" module.
9. Confirm that the AD has been successfully joined using the `realm list` command and store the output in a variable named `realm_verify`.
10. Display a list of the joined AD(s) using the `debug` module.
11. Enable SSH password authentication and restart the SSHD service using the "lineinfile" and "systemd" modules when "realm_list_output" is empty.
12. Configure users to log in without using FQDN's using the "replace" module when "realm_list_output" is empty.
13. Provide access to all AD groups for login purposes using the "realm permit" command.
14. Restart the SSSD service using the "systemd" module.
