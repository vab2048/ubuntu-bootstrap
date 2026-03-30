# Ubuntu Bootstrap

Scripts to configure Ubuntu cloud instances with known packages and utilities present. 

Where possible scripts are idempotent.

## Ubuntu Version Reference

See:
- https://en.wikipedia.org/wiki/Ubuntu_version_history

LTS Version Table:

| Version   | Code Name | Release Date | Support Until |  
|-----------|-----------|--------------|---------------|
| 22.04 LTS | Jammy     | 2022-04-21   | 2027-06-01    |
| 24.04 LTS | Noble     | 2024-04-25   | 2029-05-31    |
| 26.04 LTS | Resolute  | 2026-04-23   | 2031-05-29    |

## Script Shebang and Preamble

Scripts in this repo usually start with: 
```bash
#!/usr/bin/env bash
set -euxo pipefail
```
See:
- https://gist.github.com/akrasic/380bda362e0420be08709152c91ca1f9 for a good write up of the meaning of the commands.
- https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html - official documentation on set

This is for a number of reasons:
1. `#!/usr/bin/env bash`
   - This is the shebang line - it tells the OS which shell should run the script when it is executed as a program.
     - Note: this line does nothing if the script is sourced. It is only for when it is run as a program e.g. `./script.sh`  
   - It is using `/usr/bin/env bash` instead of `/bin/bash` directly because:
     - it finds bash using the user's PATH
     - although we are intending this to work with Ubuntu the same script, in theory, is now more portable since other Unix envs may put bash in another place. 
2. `set -euo pipefail`
   - This enables strict mode for safer scripts.
   - `-e` - exit on error
    - If any command fails, the script exits immediately - rather than trying to continue the rest of the script (which is the default behaviour)
   - `-u` - error on unset variables
      - Referencing an undefined variable becomes an error.
         - This prevents subtle bugs. 
      - E.G. `echo "$USERNAME"` 
         - without `-u`: "" i.e. echo an empty string 
         - with `-u`: bash: USERNAME: unbound variable
   - `-x` -  print the command being executed (for debugging this is useful).
   - `-o pipefail` - if you have a pipeline e.g. `curl http://www.example.com | grep foo` then the error code in the first part of the pipline is what is returned and the rest of the pipeline does not run. 

# Usage

## Lightsail

Use the following script to configure the Ubuntu instance (assumes AWS):

```sh
echo "Running as user '$USER'"
sudo apt-get update

# Git should already be installed but this is here just in case
sudo apt-get install -y git

# Clone the bootstrap repo. Notes: 
# - You need a public ipv4 address to clone from github. Currently (as of Mar 2026) ipv6 only is not supported.
# - This will clone into /opt/ubuntu-bootstrap with owner bring root 
sudo git clone https://github.com/vab2048/ubuntu-bootstrap.git /opt/ubuntu-bootstrap

# Change user:group ownership of cloned repo to $USER (on cloud this would be the 'ubuntu' user/group), so we don't
# need to keep adding sudo 
sudo chown -R $USER:$USER /opt/ubuntu-bootstrap

 
cd /opt/ubuntu-bootstrap

# (OPTIONAL) Move to branch with desired script (if not default branch of main)
# git checkout feature/script-dev

# Execute our "init" script.
chmod u+x bin/init.sh
sudo ./bin/init.sh
```

