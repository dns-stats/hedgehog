This directory contains scripts that are used to update the database as new
features and bug fixes occur. The database keeps a record of which of these has
been run. They should be run in numerical order.

To upgrade from 2.0.0b1 to 2.0.0b2 run as the user hedgehog:
  000008_ddl_traffic_difference.sh
	000009_ddl_node_index.sh