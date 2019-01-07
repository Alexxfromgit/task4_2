# task4_2

**Task 4.2 - Configuration Management "for the poor".**

Job condition:

	Create a bash **ntp_deploy.sh** script that:
    	• Installs a package with ntp server.
    	• Removes default settings from the ntp server configuration file
	  (for example, 0.ubuntu.pool.ntp.org)
    	• Prescribes ua.pool.ntp.org as an ntp server.
    	• Restarts ntp service.
    	• Register the ntp_verify.sh script once a minute for cron.
	Create a bash **ntp_verify.sh** script that:
    	• Checks if ntp process is running. If the process is not running, it starts.
    	• Checks the fact of changing the configuration file ntp.conf.
	  If there are changes, output them to stdout.
	  Returns the configuration file to the correct state and restarts the NTP service.
	  In other words, the configuration file should be maintained in the state it was created
	  by ntp_deploy.sh (that is, with the ua.pool.ntp.org ntp server, and not with the default settings).
    
Additional requirements:

    1. Bash scripts with completed tasks should be uploaded to the githab repository with the name ‘task4_2’.
    2. The githab repository ‘task4_2’ should contain 2 ntp_deploy.sh and ntp_verify.sh scripts.
    3. During the task check, the ntp_verify.sh script can be run multiple times.

Check results:

    • For each launch, a separate VM will be used (OS ubuntu xenial 16.04 server, image).
      Based on the features of CRON verification and operation,
      the sendmail package will be pre-installed on the virtual machine.
      Scripts will run from under the superuser (root). VM has access to the Internet.
    • The VM will have a repository with a task (for example, https://github.com/user/task4_2),
      if the repository has a different name, then the task will be automatically marked as failed.
    • The script will run automatically ‘ntp_deploy.sh’ from the root folder of the repository
      (if the script is named differently or is in a subfolder, it will not be launched,
      respectively, the task will be automatically marked as failed)
    • During the test, the ntp_verify.sh script can be launched from the console
      (without waiting for the scheduler to work) and its correct behavior is expected.
    • After running ntp_deploy.sh, the status of the ntp.conf configuration file will be checked.
      It is expected that it will differ from the default configuration file only
      by the configuration of NTP servers and the only configured NTP server will be ua.pool.ntp.org
    • For a while, while the VM will exist, a wide variety of changes can be made to the ntp.conf configuration file.
    
    Expected that:
        ◦ If no changes are detected, the script does not display any messages
	  anywhere and does not restart the ntp service.
        ◦ If the file has been modified, the script:
            ▪ Displays the difference in stdout.
            ▪ Restores the state of the ntp.conf file. (i.e. Default + single server ua.pool.ntp.org)
            ▪ Restarts the ntp daemon.
    • Checking that the script displayed the difference between the configuration files
      in stdout when processing the scheduler (cron) will read the file /var/mail/root
    • Before outputting the difference between the reference and modified ntp.conf file,
      the line “NOTICE: /etc/ntp.conf was changed. Calculated diff: ”.
      Sample expected message:

	NOTICE: /etc/ntp.conf was changed. Calculated diff:
		--- /etc/ntp.conf.bak   2018-03-27 16:45:40.693954805 +0000
		+++ /etc/ntp.conf       2018-03-27 16:56:55.723992297 +0000
		@@ -20 +20 @@
		-pool ua.pool.ntp.org
		+pool us.pool.ntp.org
    • Changes in the configuration file should be displayed in “unified format”.
    • During the existence of the VM after running the ntp_deploy.sh script,
      the ntp daemon can be stopped. It is expected that after the ntp_verify.sh
      script is triggered (either via cron or manually started),
      the script will output the message
      “NOTICE: ntp is not running” to stdout and start the ntp service.
