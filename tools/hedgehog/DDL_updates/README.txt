This directory contains scripts that are used to update the database
between releases. The database keeps a record of which of these has
been run. They should be run in numerical order.

2.0.0 -> 2.1.0
---------------
To upgrade from 2.0.0 to 2.1.0b1 run the following scripts in this order

* as super user of hedgehog database (e.g. postgres)
  000010_ddl_python

* as the DB write user (e.g. hedgehog):
  000011_ddl_new_graphs
  000012_ddl_lower_key_index
