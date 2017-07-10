OpenSSH for Windows v5.6p1-2: Readme
Mike Dixson
http://sshwindows.webheat.co.uk/

Updated 31 December 2011

This document is based, in large part, on and incorporates text from the Readme for OpenSSH for Windows by Michael Johnson, which was in turn based on the Readme for Network Simplicity OpenSSH on Windows by Mark Bradshaw. All similarities are due to this.

In the descriptions of what to type, I use standard command notation. Items enclosed in [] are optional. Text you need to replace with entries is enclosed in <>.

Contents
--------
- Introduction
- Known Bugs
- Installation
- Manual Uninstallation
- Configuration
- The /home directory
- Cygdrive Notation
- Terminal Emulation
- Firewalls
- Troubleshooting
- Source
- History
- Security: Should I Trust This?
- Warranty
- Final Notes



Introduction
------------
The OpenSSH server is intended for use on Windows NT-based Operating Systems. It is possible to use it on Windows 9x/ME systems, but that is not supported. The client tools will work on either platform. Most of the issues that you might encounter are documented here, so please read this document before contacting me, as I cannot guarantee a response.

NOTICE: This product uses a light version of the Cygwin utilities. This means that CYGWIN cannot be installed on the same machine. If you have cygwin installed, you can install OpenSSH through that environment. PLEASE do not try and run both this package and CYGWIN at the same time, it WILL NOT work and likely both installs will become corrupted.

SECURITY NOTICE (From the Cygwin Documentation):
"It is important that you understand the implications of Cygwin using shared memory areas to store information about Cygwin processes. Because these areas are not yet protected in any way, in principle a malicious user could modify them to cause unexpected behavior in Cygwin processes. While this is not a new problem under Windows 9x (because of the lack of operating system security), it does constitute a security hole under Windows NT. This is because one user could affect the Cygwin programs run by another user by changing the shared memory information in ways that they could not in a more typical WinNT program. For this reason, it is not appropriate to use Cygwin in high-security applications. In practice, this will not be a major problem for most uses of the library."

On a practical note, it is possible to trust the security of OpenSSH for Windows. The major rule in using this utility is to only allow trusted users to have login permissions. The cygwin port of OpenSSH uses the full OpenSSH source code and the security of the program is not diluted. The only major point of concern is the cygwin subsystem. Of course, if you allow untrusted users to have SSH access, your security is already compromised by that fact alone.

For the reasons above, this SSH server should be configured to allow only trusted administrators to log on. In the current implementation of the cygwin subsystem, you should not allow normal users to connect with SSH unless they can be trusted fully because of the possibility of an exploitation of this issue.

This program is not intended to be run in mission-critical systems. As nice as this program is, it is not running natively. Please look at a commercial solution for servers that need to be tightly secured.

That said, I have been running it on several Windows NT based systems, and have not had any major problems.


Known Bugs
----------
When connecting via SSH to use the terminal the following warning:
cygwin warning:
  MS-DOS style path detected: C:/Windows/system32/cmd.exe
  Preferred POSIX equivalent is: /cygdrive/c/Windows/system32/cmd.exe
  CYGWIN environment variable option "nodosfilewarning" turns off this warning.
  Consult the user's guide for more details about POSIX paths:
    http://cygwin.com/cygwin-ug-net/using.html#using-pathnames
This warning can be safely ignored. It's to do with the way switch.exe (now bash.exe) was originally coded. I'm working on recoding this but I'm not a C coder so it's a bit of a headache for me. Any help would be appreciated.


Installation
------------
The installation program is easy to use. Simply run the setup program and answer the prompts. If you are unsure of what it is asking, choose the default - it has been set to provide you with a sane option. The installer will create a Unix-like directory structure under the installation directory and will place files in their correct locations. Unless you are upgrading, it will then call the ssh-keygen program to create the host keys for your install. The program will also use cygrunsrv to create a service that will manage the SSHd server program. If you have trouble maintaining a connection after authenticating, reboot the server. To start the service without rebooting, use your perfered method to start the service named OpenSSHd.

NOTE: Silent installation is planned, but not currently implemented.



Manual Uninstallation
---------------------
An automatic uninstaller is provided to remove this program, but you can also uninstall manually. To do so, follow the steps below.

1.  Stop the OpenSSHd service
2.  Remove the OpenSSHd service
3.  Kill any sshd.exe and sh.exe processes that are still running
4.  Go to the directory you installed under
5.  If you want, backup the host keys under the etc directory
6.  Remove the installation directories
7.  Remove the "Cygnus Solutions" key under HKEY_LOCAL_MACHINE\SOFTWARE. You also might want to delete this key in the user hives.
8.  Remove the installation directory from the path.



Configuration
-------------
The most important step in getting the server to properly run is to correctly set up the passwd file. The passwd file is equivalent to the /etc/passwd file in UNIX-based systems. You will need to set up the passwd file before any logins can take place.

Passwd creation is fairly easy. The majority of user additions take place through the mkpasswd program. You must also create a group file with mkgroup. Mkgroup is included in the bin directory along with a slightly modified version of mkpasswd. Mkpasswd has been changed to automatically use /bin/switch as the default shell.

The steps to creating proper group and passwd files is outlined below. To add local groups to the group file, you use the -l switch, for domain groups, use the -d switch:
  mkgroup -l >> ..\etc\group      (local groups)
  mkgroup -d >> ..\etc\group      (domain groups)

If you use both commands, the group file will contain duplicates. You will need to remove these by hand in a text editor.

You will now need to create a passwd file. Any users in the passwd file will be able to log on with SSH. For this reason, it is recommended that you add users individually with the -u switch. To add ALL users on a system or domain, do not use the -u switch. As with mkgroup, local users are indicated with the -l switch and domain users are indicated by the -d switch. To add domain users from a domain that is not the primary domain of the machine, add the domain name after the user name:
  mkpasswd -l [-u <username>] >> ..\etc\passwd    (add username to passwd - local user)
  mkpasswd -d [-u <username>] >> ..\etc\passwd    (add username to passwd - domain user)

The passwd and group files are plain text and can be edited in Vim, Notepad or any text editor. Vim is recommended because it respects the default format of the files.

The last two entries for each user are safe to edit by hand, and can be customized to suit your needs. The second to last entry (/home/username) can be replaced with any other directory to act as that user's home directory (what directory they will be in after they log in). If you will be placing the user somewhere outside the default directory for their Windows profile, you will need to use the cygdrive notation explained below or edit the directory /home maps to. The last entry in passwd is the program that runs when you connect with SSH. The default shell is /bin/switch, which is the best choice for about 99.9% of the accounts you will be adding. Switch.exe allows the use of scp and sftp while still providing the standard command prompt with SSH by switching between sh.exe (scp/sftp) and cmd.exe. If you do not want sftp/scp access for a particular account you can set the shell to /bin/quietcmd.bat, which only runs cmd.exe.

Note that changes made to group are not automatically used by the ssh service. You will need to restart the OpenSSHd service before those changes can be used. Changes to passwd should be automatically used, but restarting the service will help if the changes are not applied automatically.



The /home Directory
-------------------
In the passwd file, you will notice that the user's home directory is set as /home/username, with username being the name of the account. In the default install, the /home directory is set to the default profile directory for all users. This is usually C:\Documents and Settings on Windows 2000 and XP, and C:\WINNT\Profiles on Windows NT 4.0. The location of /home can be edited to fit your special requirements by editing a registry key.

To change the Windows directory /home corresponds to, you will need to edit a registry entry under HKEY_LOCAL_MACHINE\SOFTWARE\Cygnus Solutions\Cygwin\mounts v2\/home. The value of the key named "native" is the directory that /home is. If you want all your users to enter in a directory on your machine called F:\Users, change "native" to read F:\Users. By default, each user will then be placed in the directory F:\Users\username, where username is the name of the user account. To place the user directly under f:\Users, change the home directory in passwd to /home.



Cygdrive Notation (Used in Passwd, SCP and SFTP)
------------------------------------------------
To access directories outside the installation root when using scp/sftp or for home directory entries in passwd, you will need to use a special notation called cygdrive. The cygdrive notation sets how drive letters are mapped into the UNIX-style filesystem.

To access any folder on any drive letter, add /cygdrive/DRIVELETTER/ at the beginning of the folder path. As an example, to access the winnt\system32 directory on the c: drive you would use the path:
  /cygdrive/c/winnt/system32

If you want to change the way cygdrive works, you can specify a different prefix with a registry key. You will need to add two entries under HKEY_LOCAL_MACHINE\SOFTWARE\Cygnus Solutions\Cygwin\mounts v2\. Add a REG_DWORD called "Cygdrive flags" set to 2a hex. Add a REG_SZ called "Cygdrive prefix" and set its value to the new prefix. If you set it to "/" your c drive will be accessible at /c.



Terminal Emulation
------------------
If you use the supplied client to connect to non-windows servers, you might notice that some keys do not do what you would expect, and others may not work. This behavior is usually due to terminal configuration differences between the two machines. When the Cygwin/OpenSSH client connects it tells the server that is is a Cygwin terminal, which the server might not recognize. If this is the case, you will need to tell the server what the Cygwin terminal is. If the server uses a termcap file, you can add the following lines:

cygwin:\
	:xn@:op=\E[39;49m:Km=\E[M:te=\E[2J\E[?47l\E8:ti=\E7\E[?47h:tc=linux:

If the server uses terminfo files, you can use the terminfo file in usr/share/terminfo/c/cygwin and upload it into the proper directory on the server.



Firewalls
---------
The OpenSSH server listens for traffic on TCP port 22 by default. If your firewall setup does not allow connections on this port, it can be changed by editing the etc/sshd_config file. Before going around firewall policy check that port 22 cannot be opened and that running a SSH server is allowed.



Troubleshooting
---------------
Below are some tips that should get most common problems with OpenSSH corrected:
1.  Make sure the OpenSSHd service is running under the LocalSystem (SYSTEM) account. It is the only account that has enough privileges to become any user, which logging into the SSH server requires. If it has been changed, put it back.
2.  If you will be logging into the server system FROM the server system (for testing, etc) do not set the account's home directory as "/" as there is an odd bug with this particular setup. Use /bin or something else.
3.  No account should have an encrypted passwod in the second field of passwd. NT authentication is used by the server, so make sure the field is blank or set to the default mkpasswd uses.
4.  If you get a mesage "You don't exist, go away!" when trying to log on, check the passwd file for proper formatting and to ensure that username is in the file. If you only installed the client, look for etc/passwd and remove it.
5.  If you get an setgid error when logging on, check the group file for a line that matches with the groupid listed for that user in passwd. Also make sure you restarted the service if you made changes to the group file.
6.  Note that this package is part of the full Cygwin package and it is NOT designed to run alongside Cygwin. If you installed Cygwin, either the server or Cygwin will not work, most likely both. If you need Cygwin, remove the OpenSSH server and install Cygwin's version.
7.  DLL error messages (invalid procedure point, etc) are likely caused by an old version of the Cygwin DLL. Many Unix utilities were ported with cygwin and use the DLL. Do a search for cygwin1.dll and rename or remove any other copies it fins on the server.
8.  Odd disconnects can be caused by users having cygwin mounts defined in the registry under their user account. It is best to delete the "Cygnus Solutions" key under HKEY_CURRENT_USER when the user is logged in. Note that the "Cygnus Solutions" key under HKEY_LOCAL_MACHINE is required for the server to run. Do not delete that.
9.  Make sure all sshd and cygrunsrv processes are being killed when the service is being stopped and started. You can use kill from the resource kit, pskill from sysinternals, or Windows Task Manager.
10. When testing key authentication, please use two seperate systems. Key authentication will not work if the client and server are running on the same machine.

If these tips do not resolve your situation and you want to contact me, please follow the steps below to capture debug information from the server.

1.  Make sure the scheduler service is started. (net start schedule or netstart "task scheduler" should start it)
2.  Start a command prompt running under the SYSTEM account:
      at (current time + 1 minute) /interactive %comspec%
3.  At the time specified, a new command window will appear. This window will have all the permissions of SYSTEM.
4.  Check that QuickEdit mode is turned on (it is off by default on WindowsXP). Go into properties by clicking the control widget or right-clicking the title-bar. QuickEdit is set under the Options tab.
5.  With that command window, go into the bin subdirectory of the install path.
6.  Set CYGWIN to "binmode ntsec tty":
      set CYGWIN=binmode ntsec tty
7.  Run the sshd server in highest debug mode:
      ..\usr\sbin\sshd -d -d -d

This will run the server in debug mode. If the server does not crash, try connecting to it from a client. Capture any output even if it crashes (with QuickEdit mode, highlight the text with the mouse and press the enter key to copy the text). You can then paste the debug information into a message or notepad.



Source
------
The OpenSSH utilities are from binaries provided by the Cygwin project. You can download updated versions of the utilities from http://www.cygwin.com/. The base OpenSSH source is available from http://www.openssh.com/ and the OpenSSH for Windows web site. The source for switch.exe and the modified mkpasswd.exe are included in the install.

Source will be made available at http://sshwindows.webheat.co.uk
Source for the Cygwin-specific tools is also available from a Cygwin project mirrror (http://www.cygwin.com/)



History
-------
This version of Cygwin's OpenSSH is based on the version created and maintain previously by Michael Johnson. The maintainance of his version, found at http://sshwindows.sourceforge.net seemed to fall behind, I'm sure Michael had his reasons for this.
I needed to fix a bug that I found in the last version he produced and so I went about troubleshooting this using his freely provided source code and Cygwin. Eventually fixing the bug and with Michael's scripts it was the next logical step to roll my own OpenSSH install based on his scripts and distribute it to those who also needed it.

The text below is from the OpenSSH on Windows readme for historical interest. It was written by Michael Johnson.

This version of Cygwin's OpenSSH is based on the OpenSSH install from NetworkSimplicity. This project was discontinued in late 2002 stopping at OpenSSH 3.4. Due to the need for running newer versions of the client utilities and servers, I began to work on creating a lite distribution similar to the NS project. Eventually (early 2003) I had worked out all the bugs I could find, and began using this on my own machines and released this to the public knowing someone would have the same needs I had. The text below is from the Network Simplicity OpenSSH on Windows readme for historical interest. It was written by Mark Bradshaw.


"In late 2000 my company, which uses a duke's mixture of Solaris, Linux, and Windows needed a unified remote console program.  We had been using ssh to connect to the *nix machines, but using telnet to connect to the Windows.  We did this because telnet was free and available.  I finally got fed up with the current state and set out to find a freeware SSH server for Windows.  A few days later I had to come to the conclusion that such an animal just didn't exist.

The closest thing I found was the package OpenSSH package that came with cygwin.  However, at the time it had no built-in service support, used a unixized shell, and was WAY too bulky for server use (IMO).  Around the same time I was contact by Penton Media about doing an article for Windows 2000 magazine.  It occurred to me that here was the perfect subject matter.  I was sure that I wasn't the only person currently looking for a free Windows server, so I decided to combine the two, do the article research and get an OpenSSH package made.

The article was written in December, and shortly thereafter I had a packaged installer for OpenSSH.  I shudder when I remember the "installer" of that first package, which was a cranky batch file, but it worked.  I made a few efforts at making it more generic and put it up on my web site.  

Wonder of wonders, people actually used it.  They found some bugs, and so did I.  I would correct them and drop a new version on the web site and repeat the whole process.  Eventually my own embarassment made me get serious with the installer.  The batch file just looked and felt ridiculous, so I went on a search for a freeware installer package.  The one I chose was Installer Vise, which allowed you to make free installers for freeware/shareware projects.  I used that, and came up with my first "real" installer.

I think it was around the same time that the outcry for easy scp support got to the point where I felt the need to deal with the problem.  Because I had made the decision to run with the standard Windows shell, instead of using Cygwin's ash or bash, I had a couple of problems to deal with.  The first was that scp and sftp rely on /bin/sh syntax for launching the remote side of the file transfer connection.  The Windows shell didn't support that syntax, so you had to have multiple logins for different functions.  To correct this behavior I made switch, a simple shell switcher that basically just checks for the /bin/sh syntax being passed across and launches sh.exe if necessary.  A simple concept, but one that made the whole ball of wax function. :o)

Up to this time I had not packaged sftp, because I found out that it had real problems.  The sftp app would hang whenever someone asked for a directory listing, and wouldn't do transfers of any kind to the root directory.  I had been getting more and more involved in both Cygwin and OpenSSH, so I decided it was time that the problem be solved.  Others had been posting requests for help on the cygwin mailing list, but no one had yet tracked down the problem.  After a bit of deductive work I found a few odds and ends problems with both OpenSSH and Cygwin that have since been patched (mostly).

Both OpenSSH and Cygwin continue to improve, and it's getting to the point where the tools to do most of the conversion work I did the hard way are working out of the box.  I don't know how long I'll continue to support a separate package from Cygwin's.  I think I'll keep doing it as long as I find it useful, and people keep downloading it."


Like Mark, I hope to continue to provide a seperate package of OpenSSH until a true Windows Native port is made available for free.



Security: Should I Trust This?
------------------------------
Some people reading this document are likely wondering how this package can be trusted, especially considering the sensitive nature of the work that will be conducted over this. This is a good attitude, and one that should be present in ALL the people using this program. Following are some details that may help relieve some concerns (or create new ones).

I am currently a student working in the Information Systems and Technology department at Claremont McKenna College. I have an interest in security, and have worked on security and network related projects in my duties there. I have managed systems for over four years in my personal experience. I am currently working at a Security+ certification from CompTIA and hope to have the opportunity on becoming SANS certified after that.

The source for almost all the Cygwin utilities is not included due to space considerations, and the source is freely available from the Cygwin site. The base source for OpenSSH is available from the OpenSSH site. If you want the same functionality without having to install my package, I have posted instructions for manual installation from the Cygwin binary packages at the same site this package is available from.

The real decision to make is the level of comfort you have regarding this package. If you feel that the OpenSSH team can produce a secure server and that the Cygwin project have gotten their emulation and porting correct, you should get the Cygwin distribution and install a native OpenSSH server. If you trust me to have packaged everything correctly and to not have modified the programs, you can save time and get a few nice features (like the ability to use the native command prompt). It should also be noted that I also use my package for internal use. I am releasing it hoping I can save someone else some time also. This package is the same one I use on my own computers.



Warranty
--------
    			    NO WARRANTY
    
    BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
    FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
    OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
    PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
    OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
    MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
    TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
    PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
    REPAIR OR CORRECTION.
    
    IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
    WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
    REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
    INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
    OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
    TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
    YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
    PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGES.



Final Notes
-----------
I hope this package gets some use and is enjoyed by all the Windows Admins who want something more secure than Telnet without the cost of a commercial package. OpenSSH is a great tool that I use and has saved me time. I hope someone else will get the same satisfaction out of it. If there are any suggestions, please send them to me. I will do my best to improve the package as I can.

The installer I have used for this package is NSIS, the Nullsoft Scriptable Install System. It is possibly the best totally free install system around (although suggestions on other installers are welcome). You can find NSIS at http://nsis.sourceforge.net/.



-Michael
youngmug@hotmail.com
