Active Directory Security Log Monitor
Simple PowerShell script that monitors critical Windows Security Event Logs and sends automatic email alerts to system administrators.

Overview
This project provides a lightweight monitoring tool for Active Directory environments.
The script watches the Windows Security log in real time and sends an email notification whenever a high‑risk event occurs.
It helps system administrators detect suspicious activity without manually checking Event Viewer.

Monitored Event IDs
The script alerts on the following critical security events:

4625 – Failed logon

4728 – User added to a security group

4720 – New user account created

4769 – Kerberos service ticket request

4771 – Kerberos pre‑authentication failure

7045 – New service installed

These events are commonly associated with brute force attempts, privilege escalation, Kerberoasting, persistence, and unauthorized account creation.

Email Configuration
Update the following variables inside the script:

powershell
$SMTPServer = "mail.yourdomain.com"
$From = "dc-alert@yourdomain.com"
$To = "admin@yourdomain.com"
$SubjectPrefix = "[DC Security Alert]"
Your SMTP server must allow sending emails from the domain.

How to Run
Save the script on the Domain Controller, for example:

Code
C:\SecurityMonitor\security-log-monitor.ps1
Open PowerShell as Administrator.

Run the script:

powershell
powershell.exe -ExecutionPolicy Bypass -File C:\SecurityMonitor\security-log-monitor.ps1
The script will stay active and send an email whenever a monitored event appears.

Folder Structure
Code
/security-log-monitor.ps1
Purpose
This tool helps administrators detect important security events quickly and reduces the risk of missing critical log activity in Active Directory environments.

Contributions
Pull requests and suggestions for additional Event IDs or features are welcome.
