This directory contains scripts that are used to update the database
between releases. The database keeps a record of which of these has
been run. They should be run in numerical order.

2.0.0b1 -> 2.0.0.b2
-------------------
To upgrade from 2.0.0b1 to 2.0.0b2 run the following scripts
as the user hedgehog:
  000008_ddl_traffic_difference.sh
  000009_ddl_node_index.sh

2.0.0 -> 2.1.0
---------------
000010_ddl_node_subgroup.sh
