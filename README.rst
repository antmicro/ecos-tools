ECos tools
==========

This is a repository for some minimal eCos tools.

Compiling an eCos application
-----------------------------

Create a ``config.<name>`` file and set the appropriate paths/options based on the ``config.example`` file.

Run ``make.sh <name>`` to build both kernel and application code.
Compiling the application without rebuilding the kernel is not possible at the moment.
