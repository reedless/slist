# slist
![version](https://img.shields.io/github/release/GovTechSG/slist.svg?style=flat)

slist is a tool to list your servers in ssh config and ssh into it.<br/>
This only works on Unix machines.<br/>
slist aims to solve the problem of users having to remember aliases or IP addresses of all their servers.<br/>
slist reads the aliases in the ~/.ssh/config file and list them in the terminal.

## Setting it up

```bash
cd <path_of_choice>
git clone https://github.com/GovTechSG/slist.git
chmod +x slist.sh
# Use full path of slist.sh for symlink to work
ln -s <path_of_choice>/slist.sh /usr/local/bin/slist
slist
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Screenshots

![Optional Text](../master/screenshots/slist.png)
![Optional Text](../master/screenshots/filter.png)

## Usage

Usage: slist [-fhl]
             [--add-host host_name --ip-adr ip_address [--ssh-user user --port port_number --keypath keyname_with_path]]
             [--del-host host_name]

```bash
-f <keyword>                    Keyword to filter
-h                              Display help
-l                              List servers with ip addresses
-l -f <keyword>                 Filter list work <keyword>
--add-host <host_name>          Add a new host to the SSH config file. Must be used together with --ip-adr option
--ip-adr <ip_address>           Add a new IP address to the SSH config file. Must be used together with --add-host option
--ssh-user <user>               Add a new SSH user to SSH config file. Must be used together with --add-host and --ip-adr options
--port <port_number>            Add a new port number to SSH config file. Must be used together with --add-host and --ip-adr options
--keypath <keyname_with_path>   Add a new key file to SSH config file. Must be used together with --add-host and --ip-adr options
--del-host <host_name>          Delete a host from the SSH config file
```
