ECos tools
==========

This is a repository for some minimal eCos tools.

Prerequisites
-------------

``ecosconfig`` requires the tcl compiler to work. For Debian or Ubuntu development platforms the proper package is named ``tcl8.5``, you can install it using: ``sudo apt-get install tcl8.5``.
For Gentoo platforms the package is named ``dev-lang/tcl``, you can install it using: ``sudo emerge dev-lang/tcl``.

Paths
-----

The toolkit should be relative-path-resistant, meaning that you can just put it anywhere on the system and work from your own directory.
Make a local or global symlink to ``make.sh`` if you like, keep your ``.ecc`` files wherever you want etc.

Compiling an eCos application
-----------------------------

Create a ``<name>.config`` file and set the appropriate paths/options based on the ``example.config`` file.

Run ``make.sh --config=<name>`` to build the eCos kernel. If the FILES variable was set, also build the application code and link it against the kernel.

Available flags
---------------

* ``-o=<fname>|--output-filename=<fname>`` to set an output filename if building an application, default is ``<name>``
* ``-t|--tests`` to build the eCos test suite 
* ``-r|--rebuild`` to force rebuilding the kernel 
