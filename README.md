# iocage-plugin-seafile
Artifact file(s) for Seafile iocage plugin

## Installation

Check out this repository:

`git clone git@github.com:TwilightCoders/iocage-plugin-seafile.git`

Install with `iocage` from within the project directory:
- `iocage fetch -P -n seafile.json ip4_addr="[interface]|[ip_address]/[cidr]"  vnet=off`
- e.g. `iocage fetch -P seafile.json ip4_addr="lagg0|192.168.0.222/24" vnet=off`

## Configuration

### Settings
You can read more about seafile configuration by referencing [the man pages "seafile-jail(5)"](https://www.freebsd.org/cgi/man.cgi?query=seafile-jail.conf&manpath=FreeBSD+12.0-RELEASE+and+Ports)

Mount global seafile config directory (readonly recommended, but not required):
- `iocage fstab -a seafile /path/to/dataset/for/seafile/global/conf /usr/local/etc/seafile/seafile.d nullfs ro 0 0`
- e.g. `iocage fstab -a seafile /mnt/raid1/data/seafile/global /usr/local/etc/seafile/seafile.d nullfs ro 0 0`

Example `seafile.conf` to go in `/path/to/dataset/for/seafile/global/conf`:
```sh
[Definition]

# Option: logtarget
# Notes.: Set the log target. This could be a file, SYSLOG, STDERR or STDOUT.
#         Only one log target can be specified.
#         If you change logtarget from the default value and you are
#         using logrotate -- also adjust or disable rotation in the
#         corresponding configuration file
#         (e.g. /etc/logrotate.d/seafile on Debian systems)
# Values: [ STDOUT | STDERR | SYSLOG | SYSOUT | FILE ]  Default: STDERR
#
logtarget = /var/log/seafile.log
```

Mount jail configurations (seafile calls the enabled filter/action combos 'jails', not to be confused with FreeBSD jails):
- `iocage fstab -a seafile /path/to/dataset/for/seafile/jail/conf /usr/local/etc/seafile/seafile.d nullfs ro 0 0`
- e.g. `iocage fstab -a seafile /mnt/raid1/data/seafile/jails /usr/local/etc/seafile/jail.d nullfs ro 0 0`

#### Mounts
Mount the directory where the `hosts.evil` file will be written to (outside of the jail) for persistant storage.
- `iocage fstab -a seafile /path/to/dataset/for/jail/hosts /usr/local/etc/hosts nullfs rw 0 0`
- e.g. `iocage fstab -a seafile /mnt/raid1/data/seafile/etc /usr/local/etc/hosts nullfs rw 0 0`

#### Config


## Testing
sudo iocage fetch -kP seafile/seafile.json -n seafile ip4_addr="re0|192.168.1.222/24" vnet=off

## Resources
https://www.ixsystems.com/blog/plugins-development/
https://www.ixsystems.com/community/threads/how-to-install-seafile-in-a-freebsd-jail.64121/

## Contributions
Source for the original distillation of instructions found here came from [onthax](https://www.ixsystems.com/community/threads/freenas-seafile-for-ssh-block-using-hosts-allow.61231)

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/TwilightCoders/iocage-plugin-seafile.

## License
Released under the [MIT License](http://opensource.org/licenses/MIT).
