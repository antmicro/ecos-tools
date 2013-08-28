ECos tools
==========

This is a repository for some minimal eCos tools.

Prerequisites
-------------

``ecosconfig`` requires the tcl compiler to work. For Debian or Ubuntu development platforms the proper package is named ``tcl8.5``, you can install it using: ``sudo apt-get install tcl8.5``.
For Gentoo platforms the package is named ``dev-lang/tcl``, you can install it using: ``sudo emerge dev-lang/tcl``.

Compiling an eCos program
-------------------------

Create a ``config.<name>`` file and set the appropriate paths/options based on the ``config.example`` file.
Run ``make.sh <name>`` to build both kernel and demo code. Compiling the demo without rebuilding the kernel is not possible at the moment.
