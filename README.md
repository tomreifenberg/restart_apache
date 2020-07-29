# restart_apache
Bash restart

## Usage
Clone the repository or download the latest release. 

From a command-line call re.sh with two arguments.
1. The vhost configuration
1. The service directive {restart|reload}
```sh
./re.sh 000* restart
```

With lab updates:
1. User now receives error message if attempting to reload/restart virtual host file that doesn't exist in /etc/apache2/sites-available
2. System returns list of valid files in error message.
3. System exits prior to evaluating the reload command if an invalid virtual-host is selected. 
