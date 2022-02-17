---
title: A cron job that will run conda, run python script, and email when it fails 
toc: false
layout: post
categories: [technical]
author: Hiromi Suenaga
hide: false
---

I have searched high and low trying to create a scheduled task (cron job) that will:
1. Use a conda environment
2. Run a python script
3. Email if/when errors occur


Here is my final script:

```bash
#!/bin/bash

source /opt/conda/etc/profile.d/conda.sh
conda activate my_environment

EMAIL=0

echo -e '\n>>>>> Backup >>>>>' > daily.log
python backup.py &>> daily.log || EMAIL=1
echo -e '\n>>>>> Cleanup >>>>>' >> daily.log
python cleanup.py &>> daily.log || EMAIL=1

if [[ $EMAIL == 1 ]]; then
        echo "Daily Task Failure ($0)
Time: $(date)
Hostname: $(hostname -f)
Some of the daily tasks failed.

Details:
$(cat daily.log)

Have a nice day!" | mailx -s "Daily Task Failure" dev@example.com admin@example.com 
        exit;
fi
```
In the end, I realized it is much easier to write a bash script that handles emailing rather than configuring the cron to do so with `MAILTO`, output redirects, etc.

In the next post, we will show you how to automate the creation of this cron job and other required setup using Ansible.

<br>

---
## My web searches while creating the above script

### Cron basics and `MAILTO`

[https://www.digitalocean.com/community/tutorials/how-to-use-cron-to-automate-tasks-ubuntu-1804](https://www.digitalocean.com/community/tutorials/how-to-use-cron-to-automate-tasks-ubuntu-1804)


### How to make cron send email only when script throws errors?

```
20 6-10 * * 1-5 ~/job_failure_test.sh > ~/job_fail.log 2>&1 || mail -s "Errors" myemail@something.com < ~/job_fail.log
```
[https://unix.stackexchange.com/a/314647](https://unix.stackexchange.com/a/314647)

### Why can't my cron job send emails? 

Before you uninstall Postfix and install Sendmail (not because you prefer Sendmail, but because you are not receiving emails) __check your spam/junk folder!__. That would have saved me a couple hours of struggle.

[https://tecadmin.net/install-sendmail-on-ubuntu/](https://tecadmin.net/install-sendmail-on-ubuntu/)


### How to catch an exception thrown by a python script in shell script (so I can do something like sending an email)

```bash
./script.py  || {
    # Python script script.py failed. Do something
} 
```

[https://stackoverflow.com/a/24208293/6999874](https://stackoverflow.com/a/24208293/6999874)


### How can I use conda in bash script? I get an error: CommandNotFoundError: Your shell has not been properly configured to use `conda activate`. To initialize your shell, run `$ conda init <SHELL_NAME>`

Conda puts something like this to your `.bashrc` or `.zshrc` when you install it. Just put this simplified version in the script before `conda activate`:
```
source /opt/conda/etc/profile.d/conda.sh
```

[https://unix.stackexchange.com/a/577347](https://unix.stackexchange.com/a/577347)

[https://askubuntu.com/a/1218657](https://askubuntu.com/a/1218657)
