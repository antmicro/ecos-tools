ECos tools
==========

This is a repository for some minimal eCos tools.

Prerequisites
-------------

``ecosconfig`` requires the tcl compiler to work. For Debian or Ubuntu development platforms the proper package is named ``tcl8.5``, you can install it using: ``sudo apt-get install tcl8.5``.
For Gentoo platforms the package is named ``dev-lang/tcl``, you can install it using: ``sudo emerge dev-lang/tcl``.

Compiling eCos
--------------

Create a ``<name>.config`` file and set the appropriate paths/options based on the ``example.config`` file.

Run ``make.sh --config=<name>`` to build:

* the eCos kernel if the ``.ecc`` is set to compile eCos and the *FILES* variable is empty
* your eCos application and the kernel if the *FILES* variable is set
* RedBoot if the ``.ecc`` is set to compile RedBoot

Available flags
---------------

* ``-o=<fname>|--output-filename=<fname>`` - set an output filename if building an application, default is ``<name>``
* ``-t|--tests`` - build the eCos test suite 
* ``-r|--rebuild`` - force rebuilding the kernel 

Notes
-----

* the eCos build output will be in the ``<name>_build/`` directory
* the toolkit should be relative-path-resistant, meaning that you can just put it anywhere on the system and work from your own directory.
  Make a local or global symlink to ``make.sh`` if you like, keep your ``.ecc`` files wherever you want etc.
* remember to ``--rebuild`` after you change your ``.ecc``!
