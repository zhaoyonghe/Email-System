=================================================================================
Compile & test introduction:
=================================================================================
To compile and generate the tree, run
    make TREE=root
Then you will have a tree called "root" with the below hierarchy:
/root
    /bin
        mail-in
        mail-out
    /inputs
        00001
        00002
        00003
        00004
        00005
        00006
        00007
        00008
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
    /lib
    /tmp
Then run
    make test TREE=root
to execute the test program. You can add new input files to /tests and run
    make TREE=root
    make test TREE=root
to test again.
See appendix for the test files description and expected test output.

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

2. Only one space between MAIL and FROM, RCPT and TO (1st message in tests/00008).
For example, this is not allowed:

MAIL      FROM:<username>
RCPT     TO:<username>
DATA
.

3. No space between : and < (2nd message in tests/00008)
For example, this is not allowed:

MAIL FROM: <username>
RCPT TO:<username>
DATA
.

4. Empty user name is considered as a format error and will be reported in mail-in (3rd message in tests/00008).
For example, this will cause "Current mail message is invalid: the format is incorrect or the sender is invalid!":

MAIL FROM:<reinsure>
RCPT TO:<>
DATA
Hello World!
..Hello World Again!
............
.


=================================================================================
Appendix:
=================================================================================

Test files description:

tests/00001: Multiple valid mail messages.
tests/00002: Single valid mail message.
tests/00003: Invalid mail message (no end period).
tests/00004: Invalid mail message (empty message).
tests/00005: Invalid mail messages (control lines out of order or missing).
tests/00006: Invalid mail messages (invalid sender).
tests/00007: Invalid mail messages (exists invalid recipient(s), but the messages are sent to the valid recipients).
tests/00008: Multiple valid and invalid mail messages. Only valid messages will be sent.

Expected test output:

15 mails in neckar.
1 mail in outmate.
1 mail in outroll.
7 mails in scerne.
6 mails in starshine.
1 mail in wamara.
1 mail in whaledom.




