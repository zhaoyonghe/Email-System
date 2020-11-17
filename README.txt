=================================================================================
Compile & design introduction:
=================================================================================
To compile and generate the tree, run (delete the previous tree directory if it exists):
    make install TREE=tree
Then you will have a tree called "tree" with the below hierarchy:
/tree
    /bin
        mail-in
        mail-out
    /mail
        /addleness
        /analects
        /annalistic
        /anthropomorphologically
        /blepharosphincterectomy
        /corector
        /durwaun
        /dysphasia
        /encampment
        /endoscopic
        /exilic
        /forfend
        /gorbellied
        /gushiness
        /muermo
        /neckar
        /outmate
        /outroll
        /overrich
        /philosophicotheological
        /pockwood
        /polypose
        /refluxed
        /reinsure
        /repine
        /scerne
        /starshine
        /unauthoritativeness
        /unminced
        /unrosed
        /untranquil
        /urushinic
        /vegetocarbonaceous
        /wamara
        /whaledom
This tree is protected by the linux file system permissions. The setting is as follows.
The tree directory is owned by root, making sure only root can delete tree/bin and tree/mail:
    drwxr-xr-x root root tree/
Use the same way to protect the bin and mail, making sure only root can delete binaries and mailboxes:
    drwxr-xr-x root root tree/bin/
    drwxr-xr-x root root tree/mail/
A new mailer user that belongs to the mailer group is added. All mail users (addleness to whaledom) are added to a new mailuser group. Based on that, we have:
    -r-sr-sr-x mailer mailuser tree/bin/mail-in
    ---x------ mailer mailer tree/bin/mail-out
    drwxrwx--- mailer <username> tree/mail/<username>/
Everyone can call mail-in, but only mail-in can call mail-out. Only the user itself, and mail-out, can "rwx" its own mailbox.
The message in the mailbox is like this: 
    ----rw---- mailer mailuser tree/mail/<username>/00001
Although 00001 is readable and writable by all mail users, the mailbox is protected. Thus other users cannot read and write 00001.

=================================================================================
Tests:
=================================================================================

However, using valgrind can cause problem like this, and this cannot be solved by using sudo or even running as a root:

==586== 
==586== Warning: Can't execute setuid/setgid/setcap executable: bin/mail-in
==586== Possible workaround: remove --trace-children=yes, if in effect
==586== 
valgrind: bin/mail-in: Permission denied

Valgrind works if you comment out the "sudo ./install-priv.sh" in the Makefile and install again. Thus, I handin two versions of test scripts to make the TA's life easier :)
    run_tests_no_priv.sh: It should be run when the tree is not protected, with sudo.
    run_tests.sh: It should be run when the tree is protected, with sudo. This script also includes some tests on the permission correctness.
TA can delete these two scripts when give others as hw5.

=================================================================================
Possible outputs:
=================================================================================
If the current mail message that mail-in is parsing is invalid, these two can be outputed:
    Current mail message is invalid: the format is incorrect or the sender is invalid!
    Current mail message is invalid: final message without ending with period!
If the current mail message is valid, mail-in will parse the message and pass it to mail-out several times for every recipient. Based on the return value of the mail-out, these two can be outputed:
    The message has been sent to "recipient" successfully!
    Failed to send the message to "recipient": the recipient name is not valid or other errors!

=================================================================================
Message format: corner cases assumptions:
=================================================================================
For the message format, since the homework description does not cover everything, I made some assumptions (some are from the piazza answers).
1. No blank lines between the control lines (1st message in tests/00005).
For example, this is not allowed:

MAIL FROM:<username>

RCPT TO:<username>
DATA
.

2. Only one space between MAIL and FROM, RCPT and TO.
For example, this is not allowed:

MAIL      FROM:<username>
RCPT     TO:<username>
DATA
.

3. No space between : and <.
For example, this is not allowed:

MAIL FROM: <username>
RCPT TO:<username>
DATA
.

4. Empty user name is considered as a format error and will be reported in mail-in.
For example, this will cause "Current mail message is invalid: the format is incorrect or the sender is invalid!":

MAIL FROM:<reinsure>
RCPT TO:<>
DATA
Hello World!
..Hello World Again!
............
.
