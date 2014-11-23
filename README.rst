ECos tools
==========

This is a repository for some minimal eCos tools.

Prerequisites
-------------

``ecosconfig`` requires the tcl compiler to work. For Debian or Ubuntu development platforms the proper package is named ``tcl8.5``, you can install it using: ``sudo apt-get install tcl8.5``.
For Gentoo platforms the package is named ``dev-lang/tcl``, you can install it using: ``sudo emerge dev-lang/tcl``.

Put ``ecosconfig`` in a system-wide localisation (like ``/usr/local/bin``) so that both are available from command line, using e.g. ``sudo mv ecosconfig /usr/local/bin``

.. warning::

   ``ecosconfig`` is a 32bit application, thus if you are using a 64bit OS you have to provide 32bit run-time libraries for compatibility.
   In a Debian-based Linux distributions these could be installed using the command ``sudo apt-get install ia32-libs``.

.. note::

   ``configtool``, a graphical tool for editing ``.ecc`` files, is also provided in this repository for convenience but not a prerequisite.

Compiling eCos and your application
-----------------------------------

Copy ``make.sh`` and ``example.config`` to the repository where you are developing your eCos application, renaming the latter to ``<your-app-name>.config``, and edit the file to set the appropriate paths/options based on the instructions included in the file.

If the appropriate compiler is not available in your PATH, you may create an optional ``<your-app-name>.tpath`` file in the same directory.
Put the absolute path to the toolchain's ``bin/`` directory there (i.e. ``echo "</path/to/toolchain>/bin" > <your-app-name>.tpath``
**Do not version the file with the toolchain path in your repository!** (e.g. add it to ``.gitignore``).

Run ``./make.sh --config=<your-app-name>`` to build:

* the eCos kernel if the ``.ecc`` is set to compile eCos and the *FILES* variable is empty
* your eCos application and the kernel if the *FILES* variable is set
* RedBoot if the ``.ecc`` is set to compile RedBoot

Available flags
---------------

* ``-o=<fname>|--output-filename=<fname>`` - set an output filename if building an application, default is ``<your-app-name>``
* ``-t|--tests`` - build the eCos test suite 
* ``-r|--rebuild`` - force rebuilding the kernel 

Notes
-----

* the eCos build output will be in the ``<your-app-name>_build/`` directory
* the toolkit should be relative-path-resistant, meaning that you can just put it anywhere on the system and work from your own directory.
  Make a local or global symlink to ``make.sh`` if you like, keep your ``.ecc`` files wherever you want etc.
* remember to ``--rebuild`` after you change your ``.ecc``!
