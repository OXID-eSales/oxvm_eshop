.. contents:: Table of contents

Overview
========

Current `OXID eShop <http://www.oxid-esales.com/en/home.html>`_ development
environment is inspired by `PuPHPet <https://puphpet.com/>`_ and
`Phansible <http://phansible.com/>`_ projects.

Virtual environment is built using:

* `Vagrant <https://www.vagrantup.com/>`_ - virtual environment automation tool;
* `Ansible <http://www.ansible.com/>`_ - environment orchestration tool;
* `YAML <http://yaml.org/>`_ - solution configuration.

Final solution is composed of two repositories (*linked using git sub-modules*):

* `Base VM <https://github.com/OXID-eSales/oxvm_base>`_ - Base LAMP stack
  (*also used as base for other VMs*);
* `eShop VM <https://github.com/OXID-eSales/oxvm_eshop>`_ - Current repository,
  eShop specific configuration, roles and
  `SDK components <http://wiki.oxidforge.org/SDK>`_.

Getting started
===============

Be sure to install the following **minimal dependencies**:

* `Vagrant <https://www.vagrantup.com/downloads.html>`_ (>=1.7)
* `VirtualBox <https://www.virtualbox.org/>`_ [#virtualbox_dependency]_ (>=4.2)
* `Git <https://git-scm.com/downloads>`_
* `OpenSSH <http://www.openssh.com/>`_

Quick start
-----------

* Install necessary **vagrant plugins**:

.. code:: bash

  vagrant plugin install vagrant-hostmanager
  vagrant plugin install vagrant-bindfs
  vagrant plugin install vagrant-triggers

* Clone [#recursive_clone]_ out current repository:

.. code:: bash

  git clone --recursive https://github.com/OXID-eSales/oxvm_eshop.git

* Start the VM:

.. code:: bash

  cd oxvm_eshop
  vagrant up

* After successful provision process use the following links to:

  * Open OXID eShop: http://www.oxideshop.dev/
  * Access admin area: http://www.oxideshop.dev/admin/

    * Username: ``admin``
    * Password: ``admin``

.. [#virtualbox_dependency] VirtualBox is listed as dependency due to the fact
  that it is the default chosen provider for the VM. In case other providers
  will be used there is no need to install VirtualBox. Please refer to the list
  of possible providers in the configuration section to get more information.
.. [#recursive_clone] Since the current eShop VM repository is linked through git sub-modules
  it is mandatory to use ``--recursive`` option to instruct ``git`` and clone
  base VM repository as well.

Configuration
=============

Default virtual environment configuration should be sufficient enough to get
the eShop CE/PE/EE versions up and running. However, it is possible to adjust
the configuration of virtual environment to better match personal preferences.

All configuration changes should be done by overriding variables from:

* `default.yml <https://github.com/OXID-eSales/oxvm_base/blob/master/ansible/vars/default.yml>`_ - base vm variables;
* `oxideshop.yml <https://github.com/OXID-eSales/oxvm_eshop/blob/master/ansible/vars/oxideshop.yml>`_ - eShop specific variables.

These overridden values must be placed in ``personal.yml``
[#personal_git_ignore]_ file at the root level of current repository.

For the overridden values to take effect please run ``vagrant provision``. If
the changes are related to the shared folder use ``vagrant reload``. In case the
provision process will start to show any kind of errors, please try to use
``vagrant destroy && vagrant up`` for the process to stat over from a clean
state.

Examples
--------

Below is a list of possible frequent changes which are typically done after
cloning this repository.

One can just copy ant paste the example snippets from the list bellow to the
``personal.yml`` file at the root of this repository.

Change VM provider
^^^^^^^^^^^^^^^^^^

Change VM provider from VirtualBox (*default*) to LXC.
A list of available and tested providers [#list_of_providers]_:

- `virtualbox <https://www.virtualbox.org/>`_ - Default provider which is free
  to use and available on all major operating systems;
- `lxc <https://linuxcontainers.org/>`_ [#lxc_provider]_ - Operating system
  level virtualization which vastly improves I/O performance compared to
  para-virtualization solutions;
- `parallels <http://www.parallels.com/eu/>`_ [#parallels_provider]_ - Commercial
  VM provider for OS X.

.. code:: yaml

  ---
  vagrant_local:
    vm:
      provider: lxc

Set eShop to UTF mode
^^^^^^^^^^^^^^^^^^^^^

By default shop will be installed with utf mode disabled. Its possible to turn on utf mode on first installation by changing corresponding config variable:

.. code:: yaml

  ---
  eshop:
    config:
      utf_mode: 1

If vm is already running and shop installed, please edit config.inc.php directly.

Use eShop package instead of repository
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Change the location of eShop source so that it would be compatible with
eShop packages instead of repositories [#packages_vs_repositories]_.
This should be reflected in the following configuration keys:

- ``eshop_path.source``
- ``eshop_path.modules``

A working example would be:

.. code:: yaml

  ---
  eshop_path:
    source: "{{ eshop_target_path }}"
    modules: "{{ eshop_target_path }}/modules"

Change shared folder path
^^^^^^^^^^^^^^^^^^^^^^^^^

Change the default application shared folder from ``oxideshop`` to local path
``/var/www`` and update eShop target folder [#eshop_target]_.

.. code:: yaml

  ---
  vagrant_local:
    vm:
      app_shared_folder:
        source: /var/www
        target: /var/www
  eshop_target_path: /var/www/oxideshop

Define github token for composer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Provide OAuth token from github for composer so that the access API limit could
be removed [#github_token]_.

.. code:: yaml

  ---
  php:
    composer:
      github_token: example_secret_token

Change ubuntu repository mirror url
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Change the default ubuntu repository mirror url from ``http://us.archive.ubuntu.com/ubuntu/``
to ``http://de.archive.ubuntu.com/ubuntu/``.

.. code:: yaml

  ---
  server:
    apt_mirror: http://de.archive.ubuntu.com/ubuntu/

Change virtual host
^^^^^^^^^^^^^^^^^^^

Change the default virtual host from ``www.oxideshop.dev`` to
``www.myproject.dev``.

.. code:: yaml

  ---
  vagrant_local:
    vm:
      aliases:
        - www.myproject.dev

Change MySQL password
^^^^^^^^^^^^^^^^^^^^^

Change the default MySQL user password from ``oxid`` to ``secret``.

.. code:: yaml

  ---
  mysql:
    password: secret

Trigger Varnish installation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Trigger `Varnish <https://www.varnish-cache.org/>`_ [#varnish_usage]_
installation so that it can be used within eShop.

.. code:: yaml

  ---
  varnish:
    install: true

Trigger Selenium installation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Trigger `Selenium <http://www.seleniumhq.org/>`_ installation so that it can be
used to run Selenium tests with the help of
`OXID testing library <https://github.com/OXID-eSales/testing_library.git>`_.

.. code:: yaml

  ---
  selenium:
    install: true

.. [#personal_git_ignore] ``personal.yml`` configuration file is already
  included in ``.gitignore`` and should not be visible as changes to the actual
  repository.
.. [#list_of_providers] VM solutions from `VMWare <http://www.vmware.com/>`_,
  such as `workstation <http://www.vmware.com/products/workstation>`_ and
  `fusion <http://www.vmware.com/products/fusion>`_ were not yet adapted or
  tested with our current configuration of VM.
.. [#lxc_provider] Keep in mind that LXC provider is only available for
  GNU/Linux based operating systems. In order to start using this provider with
  vagrant a plugin must be installed for it
  (``vagrant plugin install vagrant-lxc``). So far it has been only tested with
  Ubuntu based OS with lxc package installed (``sudo apt-get install lxc``).
.. [#parallels_provider] A vagrant plugin must be installed
  (``vagrant plugin install vagrant-parallels``) in order to use vagrant with
  Parallels.
.. [#packages_vs_repositories] If an eShop package is used and the configuration
  was not adjusted the provision process will checkout a fresh copy of CE
  repository on top of working directory.
.. [#eshop_target] Keep in mind that if the shared folder target does not match
  actual application (eShop) target it has to be specified explicitly by
  defining ``eshop_target_path``.
.. [#github_token] By default github has API access limits set for anonymous
  access. In order to overcome these limits one has to create a github token,
  which could be done as described in:
  https://help.github.com/articles/creating-an-access-token-for-command-line-use/
.. [#varnish_usage] Varnish can only be used with the eShop EE version and with
  purchased "performance pack" (https://www.oxid-esales.com/performance/). Keep
  in mind that the default Varnish port 6081 is being used to access the shop.
  This should also be reflected in ``config.inc.php`` file as ``sShopURL``
  parameter, e.g. http://www.oxideshop.dev:6081/ .

SDK
===

Out of the box the VM is equipped with the following SDK components:

* `Module skeleton generator <https://github.com/OXID-eSales/module_skeleton_generator>`_ - module
  which helps to create new OXID eShop modules;
* `Module certification tools <https://github.com/OXID-eSales/module_certification_tools>`_ - a
  collection of tools which allows one to see a detailed report from module
  certification process;
* `Testing library <https://github.com/OXID-eSales/testing_library>`_ - a
  library for writing various kind of tests inside eShop and a set of tools for
  running those tests.

There are also other SDK components which could be found at:
http://wiki.oxidforge.org/SDK

Usage
-----

Module skeleton generator
^^^^^^^^^^^^^^^^^^^^^^^^^

By default this module is installed under eShop's ``modules`` directory (by
default it will be ``/var/www/oxideshop/source/modules/`` which is defined by
``eshop_path.modules`` key in configuration).

The module needs to be activated manually. Further instructions on how to enable
and use the module could be found at (*installation part can be skipped*):
https://github.com/OXID-eSales/module_skeleton_generator#usage

Module certification tools
^^^^^^^^^^^^^^^^^^^^^^^^^^

By default the tools are installed under VM's home folder (``~/eshop_sdk`` which
is defined by ``eshop.sdk.path`` key in configuration). The repository of tools
is cloned out in ``~/eshop_sdk/module_certification_tools`` and an extra
shortcut ``ox_cert`` is created inside ``~/eshop_sdk/bin/`` (it's included in
``PATH`` environment variable automatically).

There is no need to do any installation part for tools to work as it is already
done by the VM's provision process.

In order to invoke the certification report generator just use the provided
shortcut:

``ox_cert <vendor_name>/<module_name>``

An example of invoking the reporting tool for module generator
[#cert_tools_call]_:

.. code:: bash

  $ ox_cert oxps/modulegenerator

After the execution it will generate a HTML document which will be placed at
``~/eshop_sdk/module_certification_tools/result/<datetime>/report.html``.

Once the report is generated one can just view the contents of it straight
from inside the VM using command line tools or copy the file to shared folder
and view it from host machine, e.g.:

.. code:: bash

  cp ~/eshop_sdk/module_certification_tools/result/20150916101719/report.html \
    /var/www/oxideshop

Testing library
^^^^^^^^^^^^^^^

Library needed for various testing purposes is already installed in the VM
through the help of `composer <https://getcomposer.org/>`_, because it's defined
in ``composer.json`` as development requirement inside eShop (at least in CE
latest development version).

All binary tools are installed inside ``/var/www/oxideshop/source/vendor/bin/``
(this value may be changed through ``eshop_path.source`` key in configuration).

A list of available binary tools:

* ``reset-shop`` - restore eShop's database to it's default state (demo);
* ``runmetrics`` - run `pdepend <http://pdepend.org/>`_ against eShop and
  modules code to collect various code metrics information;
* ``runtests`` - run unit/integartion tests against eShop and modules code;
* ``runtests-coverage`` - generate coverage report by running unit/integration
  tests;
* ``runtests-selenium`` - run acceptance tests written for Selenium.

More details on how to use and configure the library could be found at:
https://github.com/OXID-eSales/testing_library

.. [#cert_tools_call] The tools can be invoked from any working directory as
  long as the ``ox_cert`` shortcut is being used.
