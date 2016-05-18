# Cloudslang-Updater
A small powershell tool to check for new releases and update if the user chooses.

It will check from Github if any RELEASE or PRE-RELEASE is out and will write to a version file, which whill then be used to see if you already have the update installed.

In the first runtime, there will be a cloudslang folder created in C:\users\$username and the version file will be created in that folder.

1. After you check for an update, if one is found, it will append the name in the file version.
2. For now the  backup feature is not needed, but in the future, if it will be needed, I will implement it.
3. Download the update if one is available in c:\users\$username\cloudslang\cloudslang_$ver
   (It will download cslang_builder.zip and cslang-cli.zip, do a file integrity check and unpack the files)
4. Update the shortcuts for the CLI (will add shortcut for the builder aswell).
