conda-dlib
==========
This repository contains a conda recipe for automatically building the dlib Python package and uploading it to our anaconda repository, menpo. This recipe provides builds for Win32, Win64, OSX64 and Linux64 (Ubuntu 12.04 and above).

The automated builds are provided by:

  - [Travis](https://travis-ci.org/menpo/conda-dlib): Ubuntu 12.04 (x64)
  - [Appveyor](https://ci.appveyor.com/project/jabooth/conda-dlib): Windows Server 2012 R2 (x64), Also provides x86 builds
  - [Jenkins](http://jenkins.menpo.org/job/conda-dlib/): OSX 10.10

Build Settings
--------------
The following dlib functionality is **disabled** for the automated builds:

  - SSE4 for 32-bit builds
  - AVX
  - GUI support
  - BLAS on Windows (otherwise MKL is assumed via Anaconda numpy)
  - LAPACK on Windows (otherwise MKL is assumed via Anaconda numpy)

This functionality is disabled in order to attempt to increase the probability that the automated builds will be useful for as large a range of people as possible.

If the lack of this functionality is impeding you, please attempt to build the project yourself by installing [conda](http://conda.pydata.org/miniconda.html) and following the instructions below:

```
$ conda install conda-build
$ git clone https://github.com/menpo/conda-dlib
$ cd conda-dlib
$ conda config --add channels menpo
$ conda build conda/
$ conda install /PATH/TO/DLIB/PACKAGE.tar.gz
```

If you wish to edit any settings, such as enabling AVX, please edit the `build.sh` or `bld.bat` files in order to enable `(1)` or disable `(0)` the required settings. Note that in the case where you wish to achieve something like linking an external BLAS library, this may be complicated. In this event, I am unable to provide any assistance. The primary reason for providing this package was to attempt to avoid this kind of hassle in the first place!

Known Issues
------------
**In the event that you install dlib and recieve an error that is not listed below, please create an issue here on Github.**

#### `ImportError: /lib/x86_64-linux-gnu/libc.so.6: version 'GLIBC_2.14' not found`
This error stems from the fact that we build on Ubuntu 12.04, which uses GLIBC 2.14. Older versions of Linux use older versions of GLIBC which are not compatible with future versions. If we were to build using an older linux box (or the Linux Standard Base), we could remedy this issue as GLIBC is guaranteed to be backwards compatible. However, the convenience of Travis far outweighs the complexity of this. Therefore, we are currently only able to support GLIBC 2.14 and above. If this is an issue, please rebuild the project manually as described above.
