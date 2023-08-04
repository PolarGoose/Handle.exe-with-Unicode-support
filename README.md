# Sysinternals console utilities with Unicode support
Console utilities from Sysinternals such as [Du](https://learn.microsoft.com/en-us/sysinternals/downloads/du), [AccessChk](https://learn.microsoft.com/en-us/sysinternals/downloads/accesschk) and
[Handle](https://learn.microsoft.com/en-us/sysinternals/downloads/handle) do not correctly output Unicode filenames as described in the following bug descriptions:
* [Handle bug](https://superuser.com/questions/1761951/sysinternals-handle-prints-question-marks-instead-of-non-ascii-symbols)
* [Du bug](https://github.com/MicrosoftDocs/sysinternals/issues/519)
* [AccessChk bug](https://github.com/MicrosoftDocs/sysinternals/issues/420)

This repository contains versions of these utilities that have been modified using binary patches to fix the aforementioned issues.<br>
The binary patches were created by [NewcomerAl](https://github.com/NewcomerAl)<br>

# How to use
* Download and unpack the latest [release](https://github.com/PolarGoose/Sysinternals-console-utils-with-Unicode-support/releases).

# How to build the release
* Run the `Build.ps1` script.
