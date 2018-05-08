# 
# Copyright 2014, 2015, 2016 Internet Corporation for Assigned Names and Numbers.
# 
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at https://mozilla.org/MPL/2.0/.

#
# Developed by Sinodun IT (www.sinodun.com)
#

#TODO(refactor): Tidy this up so common strings are re-used and we don't need separate node and all_node versions of the same query

prepStmnt <- function(statementNm, dsccon){

    if(class(dsccon) != "try-error"){
      select_nodes_sql="AND node_id = ANY (string_to_array($6, ',')::integer[])"
      all_nodes_prep="(REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS"
      select_nodes_prep="(REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS"
      skipped_sql="NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-')"
      
        rs <- NULL
        switch(statementNm,
               getdbversion                         = { rs <- try(dbSendQuery(dsccon, "PREPARE getdbversion AS                      SELECT version FROM dsc.version;"))},
               getpltddcategories                   = { rs <- try(dbSendQuery(dsccon, "PREPARE getpltddcategories AS                SELECT DISTINCT ddcategory, cast(substring(ddcategory from 1 for position('.' in ddcategory)-1 ) as int) as in_order FROM dsc.plot WHERE ddcategory != '' order by in_order;"))},
               getpltid_ddname                      = { rs <- try(dbSendQuery(dsccon, "PREPARE getpltid_ddname (TEXT) AS            SELECT id, ddname FROM dsc.plot WHERE ddcategory=$1 ORDER BY ddname ;"))},
               getpltdetails                        = { rs <- try(dbSendQuery(dsccon, "PREPARE getpltdetails (INTEGER) AS           SELECT name, title, description, plot_id FROM dsc.plot WHERE id=$1;"))},
               getsrvrid_display_name               = { rs <- try(dbSendQuery(dsccon, "PREPARE getsrvrid_display_name AS            SELECT id, display_name FROM dsc.server ORDER BY display_name;"))},
               getsrvr_display_name_from_id         = { rs <- try(dbSendQuery(dsccon, "PREPARE getsrvr_display_name_from_id AS      SELECT display_name FROM dsc.server where id=$1;"))},
               getgroups                            = { rs <- try(dbSendQuery(dsccon, "PREPARE getgroups (INTEGER) AS               SELECT DISTINCT CASE WHEN (region='' OR region IS NULL) THEN 'Other' ELSE region END FROM dsc.node WHERE server_id=$1 ORDER BY region;"))},

               getnodes                             = { rs <- try(dbSendQuery(dsccon, "PREPARE getnodes         (INTEGER) AS        SELECT id, name, CASE WHEN (country='' OR country IS NULL) THEN 'No Country' ELSE country END as country, CASE WHEN (city='' OR city IS NULL) THEN 'No City' ELSE city END as city, CASE WHEN (subgroup='' OR subgroup IS NULL) THEN 'No Instance' ELSE subgroup END as subgroup FROM dsc.node WHERE server_id=$1 ORDER BY name;"))},
               getnodesbyregion                     = { rs <- try(dbSendQuery(dsccon, "PREPARE getnodesbyregion (INTEGER, TEXT) AS  SELECT id, name, CASE WHEN (country='' OR country IS NULL) THEN 'No Country' ELSE country END as country, CASE WHEN (city='' OR city IS NULL) THEN 'No City' ELSE city END as city, CASE WHEN (subgroup='' OR subgroup IS NULL) THEN 'No Instance' ELSE subgroup END as subgroup FROM dsc.node WHERE server_id=$1 AND region=$2 ORDER BY name;"))},

               getdatasetids                        = { rs <- try(dbSendQuery(dsccon, "PREPARE getdatasetids    (INTEGER) AS        SELECT dataset_id FROM dsc.plot WHERE id=$1;"))},
               getdefaultpltid                      = { rs <- try(dbSendQuery(dsccon, "PREPARE getdefaultpltid  (TEXT) AS           SELECT id FROM dsc.plot WHERE name=$1;"))},

               by_node                              = { rs <- try(dbSendQuery(dsccon, "PREPARE by_node                              (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, n.name AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d, dsc.node n WHERE d.node_id = n.id AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               by_node_all_nodes                    = { rs <- try(dbSendQuery(dsccon, "PREPARE by_node_all_nodes                    (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, n.name AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d, dsc.node n WHERE d.node_id = n.id AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 GROUP BY sx, skey) as sq GROUP BY x, key;"))},

               by_region                            = { rs <- try(dbSendQuery(dsccon, "PREPARE by_region                            (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, CASE WHEN (n.region   = '' OR n.region   IS NULL) THEN 'Other'       ELSE n.region   END AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d, dsc.node n WHERE d.node_id = n.id AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               by_region_all_nodes                  = { rs <- try(dbSendQuery(dsccon, "PREPARE by_region_all_nodes                  (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, CASE WHEN (n.region   = '' OR n.region   IS NULL) THEN 'Other'       ELSE n.region   END AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d, dsc.node n WHERE d.node_id = n.id AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               by_instance                          = { rs <- try(dbSendQuery(dsccon, "PREPARE by_instance                          (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, CASE WHEN (n.subgroup = '' OR n.subgroup IS NULL) THEN 'No Instance' ELSE n.subgroup END AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d, dsc.node n WHERE d.node_id = n.id AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               by_instance_all_nodes                = { rs <- try(dbSendQuery(dsccon, "PREPARE by_instance_all_nodes                (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, CASE WHEN (n.subgroup = '' OR n.subgroup IS NULL) THEN 'No Instance' ELSE n.subgroup END AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d, dsc.node n WHERE d.node_id = n.id AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               by_city                              = { rs <- try(dbSendQuery(dsccon, "PREPARE by_city                              (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, CASE WHEN (n.city     = '' OR n.city     IS NULL) THEN 'No City'     ELSE n.city     END AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d, dsc.node n WHERE d.node_id = n.id AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               by_city_all_nodes                    = { rs <- try(dbSendQuery(dsccon, "PREPARE by_city_all_nodes                    (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, CASE WHEN (n.city     = '' OR n.city     IS NULL) THEN 'No City'     ELSE n.city     END AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d, dsc.node n WHERE d.node_id = n.id AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               by_country                           = { rs <- try(dbSendQuery(dsccon, "PREPARE by_country                           (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, CASE WHEN (n.country  = '' OR n.country  IS NULL) THEN 'No Country'  ELSE n.country  END AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d, dsc.node n WHERE d.node_id = n.id AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               by_country_all_nodes                 = { rs <- try(dbSendQuery(dsccon, "PREPARE by_country_all_nodes                 (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, CASE WHEN (n.country  = '' OR n.country  IS NULL) THEN 'No Country'  ELSE n.country  END AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d, dsc.node n WHERE d.node_id = n.id AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 GROUP BY sx, skey) as sq GROUP BY x, key;"))},

               f1                                   = { rs <- try(dbSendQuery(dsccon, "PREPARE f1                                   (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT starttime   AS sx, key1 AS skey, sum(value)/60.0 AS sy FROM dsc.data WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f1_all_nodes                         = { rs <- try(dbSendQuery(dsccon, "PREPARE f1_all_nodes                         (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT starttime   AS sx, key1 AS skey, sum(value)/60.0 AS sy FROM dsc.data WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f1lookupcodes                        = { rs <- try(dbSendQuery(dsccon, "PREPARE f1lookupcodes                        (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT, TEXT) AS     select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, CASE WHEN il.name IN ('FormErr', 'NotImp', 'YXDomain', 'YXRRSet', 'NotAuth', 'NotZone', 'BADKEY', 'BADTIME', 'BADMODE', 'BADNAME', 'BADALG', 'BADTRUNC', 'BADVERS') THEN 'Other' WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key1::text = il.value::text AND il.registry::text = $5 WHERE d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 AND d.node_id = ANY (string_to_array($6, ',')::integer[]) GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f1lookupcodes_all_nodes              = { rs <- try(dbSendQuery(dsccon, "PREPARE f1lookupcodes_all_nodes              (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, CASE WHEN il.name IN ('FormErr', 'NotImp', 'YXDomain', 'YXRRSet', 'NotAuth', 'NotZone', 'BADKEY', 'BADTIME', 'BADMODE', 'BADNAME', 'BADALG', 'BADTRUNC', 'BADVERS') THEN 'Other' WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key1::text = il.value::text AND il.registry::text = $5 WHERE d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f1lookupcodesnoquery                 = { rs <- try(dbSendQuery(dsccon, "PREPARE f1lookupcodesnoquery                 (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key1::text = il.value::text AND il.registry::text = $5 WHERE d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 AND d.node_id = ANY (string_to_array($6, ',')::integer[]) AND d.key1 !='Query' GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f1lookupcodesnoquery_all_nodes       = { rs <- try(dbSendQuery(dsccon, "PREPARE f1lookupcodesnoquery_all_nodes       (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key1::text = il.value::text AND il.registry::text = $5 WHERE d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 AND d.key1 !='Query' GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f1noclr                              = { rs <- try(dbSendQuery(dsccon, "PREPARE f1noclr                              (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT starttime   AS sx, key1 AS skey, sum(value)/60.0 AS sy FROM dsc.data WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND node_id = ANY (string_to_array($5, ',')::integer[]) AND key1 !='clr' GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f1noclr_all_nodes                    = { rs <- try(dbSendQuery(dsccon, "PREPARE f1noclr_all_nodes                    (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT starttime   AS sx, key1 AS skey, sum(value)/60.0 AS sy FROM dsc.data WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND key1 !='clr' GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f1count                              = { rs <- try(dbSendQuery(dsccon, "PREPARE f1count                              (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT starttime   AS sx, key1 AS skey, sum(value) AS sy FROM dsc.data WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f1count_all_nodes                    = { rs <- try(dbSendQuery(dsccon, "PREPARE f1count_all_nodes                    (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT starttime   AS sx, key1 AS skey, sum(value) AS sy FROM dsc.data WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f1nonormal                           = { rs <- try(dbSendQuery(dsccon, "PREPARE f1nonormal                           (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT starttime   AS sx, key1 AS skey, sum(value)/60.0 AS sy FROM dsc.data WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND node_id = ANY (string_to_array($5, ',')::integer[]) AND key1 !='normal' GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f1nonormal_all_nodes                 = { rs <- try(dbSendQuery(dsccon, "PREPARE f1nonormal_all_nodes                 (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT starttime   AS sx, key1 AS skey, sum(value)/60.0 AS sy FROM dsc.data WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND key1 !='normal' GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f2mergekeys                          = { rs <- try(dbSendQuery(dsccon, "PREPARE f2mergekeys                          (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, d.key1 || ':' || key2 AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d WHERE d.key1 != 'else' AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f2mergekeys_all_nodes                = { rs <- try(dbSendQuery(dsccon, "PREPARE f2mergekeys_all_nodes                (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, d.key1 || ':' || key2 AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d WHERE d.key1 != 'else' AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f2mergekeys_lookup                   = { rs <- try(dbSendQuery(dsccon, "PREPARE f2mergekeys_lookup                   (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, d.key1 || ':' || CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key2::text = il.value::text AND il.registry::text='qtype' WHERE d.key1 != 'else' AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f2mergekeys_lookup_all_nodes         = { rs <- try(dbSendQuery(dsccon, "PREPARE f2mergekeys_lookup_all_nodes         (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, d.key1 || ':' || CASE WHEN il.name IS NULL then 'Other' ELSE il.name END AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key2::text = il.value::text AND il.registry::text='qtype' WHERE d.key1 != 'else' AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f2mergekeys_lookup_key1              = { rs <- try(dbSendQuery(dsccon, "PREPARE f2mergekeys_lookup_key1              (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, il.name || ':' || key2 AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d, iana_lookup il WHERE il.registry::text='qtype' AND key1::text = il.value::text AND d.key1 != 'else' AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f2mergekeys_lookup_key1_all_nodes    = { rs <- try(dbSendQuery(dsccon, "PREPARE f2mergekeys_lookup_key1_all_nodes    (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT d.starttime AS sx, il.name || ':' || key2 AS skey, sum(d.value)/60.0 AS sy FROM dsc.data d, iana_lookup il WHERE il.registry::text='qtype' AND key1::text = il.value::text AND d.key1 != 'else' AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f2sumkey2values                      = { rs <- try(dbSendQuery(dsccon, "PREPARE f2sumkey2values                      (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT starttime   AS sx, key1 AS skey, sum(value)/60.0 AS sy FROM dsc.data WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               f2sumkey2values_all_nodes            = { rs <- try(dbSendQuery(dsccon, "PREPARE f2sumkey2values_all_nodes            (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 select to_timestamp((extract(epoch from sq.sx)::int / (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*(extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x, sq.skey as key, avg(sq.sy) as y from (SELECT starttime   AS sx, key1 AS skey, sum(value)/60.0 AS sy FROM dsc.data WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 GROUP BY sx, skey) as sq GROUP BY x, key;"))},
               format3                              = { rs <- try(dbSendQuery(dsccon, "PREPARE format3                        (REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS           SELECT dsc.iptruncate(key2::ipaddress) AS x, sum(value)/$1 AS y FROM dsc.data WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND node_id = ANY (string_to_array($6, ',')::integer[]) AND key2 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') GROUP BY x ORDER BY y DESC LIMIT 40;"))},
               format3_all_nodes                    = { rs <- try(dbSendQuery(dsccon, "PREPARE format3_all_nodes              (REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                 SELECT dsc.iptruncate(key2::ipaddress) AS x, sum(value)/$1 AS y FROM dsc.data WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND key2 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') GROUP BY x ORDER BY y DESC LIMIT 40;"))},

               client_addr_vs_rcode_accum           = { rs <- try(dbSendQuery(dsccon, "PREPARE client_addr_vs_rcode_accum               (REAL, INTEGER, INTEGER,     TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS  SELECT dsc.iptruncate(key1::ipaddress) AS x, il.name AS key, sum(d.value)/$1 As y FROM dsc.data d, iana_lookup il WHERE server_id=$2 AND d.plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND node_id = ANY (string_to_array($6, ',')::integer[]) AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') AND il.registry = 'rcode' AND d.key2::text = il.value::text AND dsc.iptruncate(key1::ipaddress) IN (SELECT dsc.iptruncate(key1::ipaddress) AS k1 FROM dsc.data WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND node_id = ANY (string_to_array($6, ',')::integer[]) AND key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') GROUP BY k1 ORDER BY sum(value)/$1 DESC LIMIT 40) GROUP BY x, key;"))},
               client_addr_vs_rcode_accum_all_nodes = { rs <- try(dbSendQuery(dsccon, "PREPARE client_addr_vs_rcode_accum_all_nodes     (REAL, INTEGER, INTEGER,     TIMESTAMPTZ, TIMESTAMPTZ) AS        SELECT dsc.iptruncate(key1::ipaddress) AS x, il.name AS key, sum(d.value)/$1 As y FROM dsc.data d, iana_lookup il WHERE server_id=$2 AND d.plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') AND il.registry = 'rcode' AND d.key2::text = il.value::text AND dsc.iptruncate(key1::ipaddress) IN (SELECT dsc.iptruncate(key1::ipaddress) AS k1 FROM dsc.data WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') GROUP BY k1 ORDER BY sum(value)/$1 DESC LIMIT 40) GROUP BY x, key;"))},
               qtype_vs_qnamelen                    = { rs <- try(dbSendQuery(dsccon, "PREPARE qtype_vs_qnamelen                     (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS               SELECT il.name AS key, cast(d.key2 AS int) AS x, sum(d.value) AS y FROM dsc.data d, iana_lookup il WHERE server_id=$1 AND d.plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND node_id = ANY (string_to_array($5, ',')::integer[]) AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') AND il.registry = 'qtype' AND d.key1::text = il.value::text AND cast(d.key2 AS int) < 100 GROUP BY key, x;"))},
               qtype_vs_qnamelen_all_nodes          = { rs <- try(dbSendQuery(dsccon, "PREPARE qtype_vs_qnamelen_all_nodes           (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                     SELECT il.name AS key, cast(d.key2 AS int) AS x, sum(d.value) AS y FROM dsc.data d, iana_lookup il WHERE server_id=$1 AND d.plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') AND il.registry = 'qtype' AND d.key1::text = il.value::text AND cast(d.key2 AS int) < 100 GROUP BY key, x;"))},
               rcode_vs_replylen                    = { rs <- try(dbSendQuery(dsccon, "PREPARE rcode_vs_replylen                     (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS               SELECT il.name AS key, key2::integer AS x, d.value AS y FROM dsc.data d, iana_lookup il WHERE server_id=$1 AND d.plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND node_id = ANY (string_to_array($5, ',')::integer[]) AND il.registry = 'rcode' AND d.key1::text = il.value::text AND key2::integer < 1000;"))},
               rcode_vs_replylen_all_nodes          = { rs <- try(dbSendQuery(dsccon, "PREPARE rcode_vs_replylen_all_nodes           (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                     SELECT il.name AS key, key2::integer AS x, d.value AS y FROM dsc.data d, iana_lookup il WHERE server_id=$1 AND d.plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND il.registry = 'rcode' AND d.key1::text = il.value::text AND key2::integer < 1000;"))},
               rcode_vs_replylen_big                = { rs <- try(dbSendQuery(dsccon, "PREPARE rcode_vs_replylen_big                 (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS               SELECT il.name AS key, key2::integer AS x, d.value AS y FROM dsc.data d, iana_lookup il WHERE server_id=$1 AND d.plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND node_id = ANY (string_to_array($5, ',')::integer[]) AND il.registry = 'rcode' AND d.key1::text = il.value::text AND key2::integer >= 1000;"))},
               rcode_vs_replylen_big_all_nodes      = { rs <- try(dbSendQuery(dsccon, "PREPARE rcode_vs_replylen_big_all_nodes       (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                     SELECT il.name AS key, key2::integer AS x, d.value AS y FROM dsc.data d, iana_lookup il WHERE server_id=$1 AND d.plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND il.registry = 'rcode' AND d.key1::text = il.value::text AND key2::integer >= 1000;"))},
               client_subnet2_accum                 = { rs <- try(dbSendQuery(dsccon, "PREPARE client_subnet2_accum                     (REAL, INTEGER, INTEGER,     TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS  SELECT dsc.iptruncate(key1::ipaddress) AS x, key2 AS key, sum(value)/$1 As y FROM dsc.data WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND node_id = ANY (string_to_array($6, ',')::integer[]) AND substring(key1 FROM '^([0-9]*.)|.*:.*') IN (SELECT substring(key1 FROM '^([0-9]*.)|.*:.*')::text AS k1 FROM dsc.data WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND node_id = ANY (string_to_array($6, ',')::integer[]) AND key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') GROUP BY k1 ORDER BY sum(value)/$1 DESC LIMIT 40) GROUP BY x, key;"))},
               client_subnet2_accum_all_nodes       = { rs <- try(dbSendQuery(dsccon, "PREPARE client_subnet2_accum_all_nodes           (REAL, INTEGER, INTEGER,     TIMESTAMPTZ, TIMESTAMPTZ) AS        SELECT dsc.iptruncate(key1::ipaddress) AS x, key2 AS key, sum(value)/$1 As y FROM dsc.data WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND substring(key1 FROM '^([0-9]*.)|.*:.*') IN (SELECT substring(key1 FROM '^([0-9]*.)|.*:.*')::text AS k1 FROM dsc.data WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') GROUP BY k1 ORDER BY sum(value)/$1 DESC LIMIT 40) GROUP BY x, key;"))},
               dns_ip_version_vs_qtype              = { rs <- try(dbSendQuery(dsccon, "PREPARE dns_ip_version_vs_qtype                  (REAL, INTEGER, INTEGER,     TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS  SELECT d.key1 AS x, CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS key, sum(d.value)/$1 As y FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key2::text = il.value::text AND il.registry = 'qtype' WHERE d.server_id=$2 AND d.plot_id=$3 AND d.starttime>=$4 AND d.starttime<=$5 AND d.node_id = ANY (string_to_array($6, ',')::integer[]) AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') GROUP BY x, key ORDER BY y DESC;"))},
               dns_ip_version_vs_qtype_all_nodes    = { rs <- try(dbSendQuery(dsccon, "PREPARE dns_ip_version_vs_qtype_all_nodes        (REAL, INTEGER, INTEGER,     TIMESTAMPTZ, TIMESTAMPTZ) AS        SELECT d.key1 AS x, CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS key, sum(d.value)/$1 As y FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key2::text = il.value::text AND il.registry = 'qtype' WHERE d.server_id=$2 AND d.plot_id=$3 AND d.starttime>=$4 AND d.starttime<=$5 AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') GROUP BY x, key ORDER BY y DESC;"))},

               traffic_volume                       = { rs <- try(dbSendQuery(dsccon, "PREPARE traffic_volume                   (INTEGER, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS      SELECT starttime AS x, 'dns-' || key1 || '-queries-received-' || lower(key2) AS key, sum(value) AS y FROM dsc.data d WHERE server_id=$1 AND plot_id=$2 AND starttime>=$4 AND starttime<=$5 AND d.node_id = ANY (string_to_array($6, ',')::integer[]) GROUP BY x, key UNION SELECT starttime AS x, 'dns-' || key1 || '-responses-sent-' || lower(key2) AS key, sum(value) AS y FROM dsc.data d WHERE server_id=$1 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND d.node_id = ANY (string_to_array($6, ',')::integer[]) GROUP BY x, key;"))},
               traffic_volume_all_nodes             = { rs <- try(dbSendQuery(dsccon, "PREPARE traffic_volume_all_nodes         (INTEGER, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS            SELECT starttime AS x, 'dns-' || key1 || '-queries-received-' || lower(key2) AS key, sum(value) AS y FROM dsc.data WHERE server_id=$1 AND plot_id=$2 AND starttime>=$4 AND starttime<=$5 GROUP BY x, key UNION SELECT starttime AS x, 'dns-' || key1 || '-responses-sent-' || lower(key2) AS key, sum(value) AS y FROM dsc.data WHERE server_id=$1 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 GROUP BY x, key;"))},
               # Following two statements are used to generate yaml data, but not for a visible plot
               traffic_sizes                        = { rs <- try(dbSendQuery(dsccon, "PREPARE traffic_sizes                    (INTEGER, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS      SELECT key1 || '-request-sizes' AS key, ((key2::integer/16) * 16) + 7.5 AS x, sum(value) AS y FROM dsc.data d WHERE server_id=$1 AND plot_id=$2 AND starttime>=$4 AND starttime<=$5 AND d.node_id = ANY (string_to_array($6, ',')::integer[]) GROUP BY key, x UNION SELECT key1 || '-response-sizes' AS key, ((key2::integer/16) * 16) + 7.5 AS x, sum(value) AS y FROM dsc.data d WHERE server_id=$1 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5  AND d.node_id = ANY (string_to_array($6, ',')::integer[]) GROUP BY key, x ORDER BY x;"))},
               traffic_sizes_all_nodes              = { rs <- try(dbSendQuery(dsccon, "PREPARE traffic_sizes_all_nodes          (INTEGER, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS            SELECT key1 || '-request-sizes' AS key, ((key2::integer/16) * 16) + 7.5 AS x, sum(value) AS y FROM dsc.data   WHERE server_id=$1 AND plot_id=$2 AND starttime>=$4 AND starttime<=$5 GROUP BY key, x UNION SELECT key1 || '-response-sizes' AS key, ((key2::integer/16) * 16) + 7.5 AS x, sum(value) AS y FROM dsc.data WHERE server_id=$1 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 GROUP BY key, x ORDER BY x;"))},
               traffic_sizes_small                  = { rs <- try(dbSendQuery(dsccon, "PREPARE traffic_sizes_small              (INTEGER, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS      SELECT key1 || '-request-sizes' AS key, ((key2::integer/16) * 16) + 7.5 AS x, sum(value) AS y FROM dsc.data d WHERE server_id=$1 AND plot_id=$2 AND starttime>=$4 AND starttime<=$5 AND key2::integer < 1000 AND d.node_id = ANY (string_to_array($6, ',')::integer[]) GROUP BY key, x UNION SELECT key1 || '-response-sizes' AS key, ((key2::integer/16) * 16) + 7.5 AS x, sum(value) AS y FROM dsc.data d WHERE server_id=$1 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND key2::integer < 1000 AND d.node_id = ANY (string_to_array($6, ',')::integer[]) GROUP BY key, x ORDER BY x;"))},
               traffic_sizes_small_all_nodes        = { rs <- try(dbSendQuery(dsccon, "PREPARE traffic_sizes_small_all_nodes    (INTEGER, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS            SELECT key1 || '-request-sizes' AS key, ((key2::integer/16) * 16) + 7.5 AS x, sum(value) AS y FROM dsc.data   WHERE server_id=$1 AND plot_id=$2 AND starttime>=$4 AND starttime<=$5 AND key2::integer < 1000 GROUP BY key, x UNION SELECT key1 || '-response-sizes' AS key, ((key2::integer/16) * 16) + 7.5 AS x, sum(value) AS y FROM dsc.data WHERE server_id=$1 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND key2::integer < 1000 GROUP BY key, x ORDER BY x;"))},
               traffic_sizes_big                    = { rs <- try(dbSendQuery(dsccon, "PREPARE traffic_sizes_big                (INTEGER, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS      SELECT key1 || '-request-sizes' AS key, ((key2::integer/16) * 16) + 7.5 AS x, sum(value) AS y FROM dsc.data d WHERE server_id=$1 AND plot_id=$2 AND starttime>=$4 AND starttime<=$5 AND key2::integer >= 1000 AND d.node_id = ANY (string_to_array($6, ',')::integer[]) GROUP BY key, x UNION SELECT key1 || '-response-sizes' AS key, ((key2::integer/16) * 16) + 7.5 AS x, sum(value) AS y FROM dsc.data d WHERE server_id=$1 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND key2::integer >= 1000 AND d.node_id = ANY (string_to_array($6, ',')::integer[]) GROUP BY key, x ORDER BY x;"))},
               traffic_sizes_big_all_nodes          = { rs <- try(dbSendQuery(dsccon, "PREPARE traffic_sizes_big_all_nodes      (INTEGER, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS            SELECT key1 || '-request-sizes' AS key, ((key2::integer/16) * 16) + 7.5 AS x, sum(value) AS y FROM dsc.data   WHERE server_id=$1 AND plot_id=$2 AND starttime>=$4 AND starttime<=$5 AND key2::integer >= 1000 GROUP BY key, x UNION SELECT key1 || '-response-sizes' AS key, ((key2::integer/16) * 16) + 7.5 AS x, sum(value) AS y FROM dsc.data WHERE server_id=$1 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5 AND key2::integer >= 1000 GROUP BY key, x ORDER BY x;"))},
               rcode_volume                         = { rs <- try(dbSendQuery(dsccon, "PREPARE rcode_volume                     (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS               SELECT d.starttime AS x, d.key1 AS key, sum(d.value) AS y FROM dsc.data d WHERE d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY x, key;"))},
               rcode_volume_all_nodes               = { rs <- try(dbSendQuery(dsccon, "PREPARE rcode_volume_all_nodes           (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                     SELECT d.starttime AS x, d.key1 AS key, sum(d.value) AS y FROM dsc.data d WHERE d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 GROUP BY x, key;"))},
               unique_sources_raw                   = { rs <- try(dbSendQuery(dsccon, "PREPARE unique_sources_raw               (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS               SELECT key1 as x, count(key2) AS y FROM dsc.data as d WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY x UNION SELECT 'IPv6/64' as x, count(*) as y from (SELECT substring(key2 FROM '(^([0-9a-f]{1,4}:{0,1}[0-9a-f]{0,4}:{0,1}[0-9a-f]{0,4}:{0,1}[0-9a-f]{0,4}))') as subnet FROM dsc.data as d WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND key1='IPv6' AND d.node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY subnet) AS sq ORDER BY y DESC;"))},
               unique_sources_raw_all_nodes         = { rs <- try(dbSendQuery(dsccon, "PREPARE unique_sources_raw_all_nodes     (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                     SELECT key1 as x, count(key2) AS y FROM dsc.data WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 GROUP BY x UNION SELECT 'IPv6/64' as x, count(*) as y from (SELECT substring(key2 FROM '(^([0-9a-f]{1,4}:{0,1}[0-9a-f]{0,4}:{0,1}[0-9a-f]{0,4}:{0,1}[0-9a-f]{0,4}))') as subnet FROM dsc.data WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND key1='IPv6' GROUP BY subnet) AS sq ORDER BY y DESC;"))},
               unique_sources                       = { rs <- try(dbSendQuery(dsccon, "PREPARE unique_sources                   (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS               SELECT key1 as x, sum(value) AS y FROM dsc.data as d WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) GROUP BY x order by y DESC;"))},
               unique_sources_all_nodes             = { rs <- try(dbSendQuery(dsccon, "PREPARE unique_sources_all_nodes         (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                     SELECT key1 as x, sum(value) AS y FROM dsc.data WHERE server_id=$1 AND plot_id=$2 AND starttime>=$3 AND starttime<=$4 GROUP BY x order by y desc;"))},
               load_time                            = { rs <- try(dbSendQuery(dsccon, "PREPARE load_time                        (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS               SELECT d.starttime AS x, n.name AS key, d.value AS y, d.key2 as serial FROM dsc.data d, dsc.node n WHERE d.node_id = n.id AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) order by serial;"))},
               load_time_all_nodes                  = { rs <- try(dbSendQuery(dsccon, "PREPARE load_time_all_nodes              (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                     SELECT d.starttime AS x, n.name AS key, d.value AS y, d.key2 as serial FROM dsc.data d, dsc.node n WHERE d.node_id = n.id AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 order by serial;"))},
               zone_size                            = { rs <- try(dbSendQuery(dsccon, "PREPARE zone_size                        (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS               SELECT d.starttime, avg(d.value) AS y, d.key2 AS x FROM dsc.data d, dsc.node n WHERE d.node_id = n.id AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) group by d.starttime, d.key2 order by x;"))},
               zone_size_all_nodes                  = { rs <- try(dbSendQuery(dsccon, "PREPARE zone_size_all_nodes              (INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS                     SELECT d.starttime, avg(d.value) AS y, d.key2 AS x FROM dsc.data d, dsc.node n WHERE d.node_id = n.id AND d.server_id=$1 AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4 group by d.starttime, d.key2 order by x;"))},

               geomap = {
                 sql_joined <- paste("PREPARE", statementNm, "(INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS
                 select g.latitude || ':' || g.longitude as location, sum(d.value) 
                 FROM dsc.data d, geoip g where cast(d.key2 as ipaddress) <<= g.ip_range 
                 and server_id=$1 AND plot_id=$2 AND d.starttime >=$3 
                 AND starttime<=$4 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) 
                 and d.key2 not in ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
                 group by location;", sep=" ")
                sql=gsub("\n"," ",sql_joined)
                rs <- try(dbSendQuery(dsccon, sql))},
               
               geomap_all_nodes = {
                 sql_joined <- paste("PREPARE", statementNm, "(INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS
                 select g.latitude || ':' || g.longitude as location, sum(d.value) 
                 FROM dsc.data d, geoip g 
                 where cast(d.key2 as ipaddress) <<= g.ip_range 
                 and server_id=$1 AND plot_id=$2 AND d.starttime >=$3 
                 AND starttime<=$4 and d.key2 not in ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
                 group by location;", sep=" ")
                sql=gsub("\n"," ",sql_joined)
                rs <- try(dbSendQuery(dsccon, sql))},
               
               geochart = {
                 sql_joined <- paste("PREPARE", statementNm, "(INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS
                 select l.name as location, sum(d.value) as count, 1 as color, 'Queries' as type 
                 FROM dsc.data d, geoip g, locations l  
                 where cast(d.key2 as ipaddress) <<= g.ip_range 
                 and l.geoname_id=g.geoname and server_id=$1 AND plot_id=$2 
                 AND d.starttime >=$3 AND starttime<=$4 
                 AND d.node_id = ANY (string_to_array($5, ',')::integer[]) 
                 and d.key2 not in ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
                 group by location 
                 union 
                 select n.city as location, count(*), 2 as color, n.city || ' nodes' as type 
                 from node n 
                 where n.id = ANY (string_to_array($5, ',')::integer[])
                 and server_id=$1 and n.city!='' and n.city IS NOT NULL
                 group by n.city;", sep=" ")
                sql=gsub("\n"," ",sql_joined)
                rs <- try(dbSendQuery(dsccon, sql))},
               
               geochart_all_nodes = {
                 sql_joined <- paste("PREPARE", statementNm,  "(INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS
                 select l.name as location, sum(d.value) as count, 1 as color, 'Queries' as type 
                 FROM dsc.data d, geoip g, locations l  
                 where cast(d.key2 as ipaddress) <<= g.ip_range 
                   and l.geoname_id=g.geoname and server_id=$1 AND plot_id=$2 
                   AND d.starttime >=$3 AND starttime<=$4 
                   and d.key2 not in ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
                 group by location 
                 union 
                 select n.city as location, count(*), 2 as color, n.city || ' nodes' as type 
                 from node n
                 where server_id=$1 and n.city!='' and n.city IS NOT NULL
                 group by n.city;", sep=" ")
                sql=gsub("\n"," ",sql_joined)
                rs <- try(dbSendQuery(dsccon, sql))},

               format3_bgpprefix  = {
                 sql_joined <- paste("PREPARE", statementNm, select_nodes_prep,
                 "SELECT xx / ip2bgpprefix(xx) AS x, sum(y) as y FROM
                  (SELECT key2::ipaddress AS xx, sum(value)/$1 AS y 
                  FROM dsc.data 
                  WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5",
                  select_nodes_sql,
                  "AND key2", skipped_sql,
                  "GROUP BY xx ORDER BY y DESC LIMIT 40) as sq
                group by x order by y desc;", sep=" ")
                sql=gsub("\n"," ",sql_joined)
                rs <- try(dbSendQuery(dsccon, sql))},
               
               format3_bgpprefix_all_nodes= {
                 sql_joined <- paste("PREPARE", statementNm, all_nodes_prep, 
                 "SELECT xx / ip2bgpprefix(xx) AS x, sum(y) as y FROM 
                  (SELECT key2::ipaddress AS xx, sum(value)/$1 AS y
                   FROM dsc.data
                   WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5
                   AND key2", skipped_sql,
                  "GROUP BY xx ORDER BY y DESC LIMIT 40) as sq
                group by x order by y desc;", sep=" ")
                sql=gsub("\n"," ",sql_joined)
                rs <- try(dbSendQuery(dsccon, sql))},

               format3_asn = {
                 sql_joined <- paste("PREPARE", statementNm, select_nodes_prep,
                 "SELECT ip2asn(xx) AS x, sum(y) as y FROM
                  (SELECT key2::ipaddress AS xx, sum(value)/$1 AS y 
                   FROM dsc.data 
                   WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5",
                   select_nodes_sql,
                   "AND key2", skipped_sql,
                  "GROUP BY xx ORDER BY y DESC LIMIT 40) as sq
                group by x order by y desc;", sep=" ")
                sql=gsub("\n"," ",sql_joined)
                rs <- try(dbSendQuery(dsccon, sql))},
               
               format3_asn_all_nodes = {
                 sql_joined <- paste("PREPARE", statementNm, all_nodes_prep, 
                 "SELECT ip2asn(xx) AS x, sum(y) as y FROM 
                  (SELECT key2::ipaddress AS xx, sum(value)/$1 AS y 
                   FROM dsc.data 
                   WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5
                   AND key2", skipped_sql,
                  "GROUP BY xx ORDER BY y DESC LIMIT 40) as sq
                group by x order by y desc;", sep=" ")
                 sql=gsub("\n"," ",sql_joined)
                 rs <- try(dbSendQuery(dsccon, sql))},
               
               client_addr_vs_rcode_accum_asn = {
               sql_joined <- paste("PREPARE", statementNm, select_nodes_prep,
                 "SELECT dsc.ip2asn(xx) AS x, key, sum(y) as y FROM 
                  (SELECT key1::ipaddress AS xx, il.name AS key, sum(d.value)/$1 As y 
                   FROM dsc.data d, iana_lookup il 
                   WHERE server_id=$2 AND d.plot_id=$3 AND starttime>=$4 AND starttime<=$5
                   AND d.key1", skipped_sql,
                   "AND il.registry = 'rcode' AND d.key2::text = il.value::text",
                   select_nodes_sql,
                   "GROUP BY xx, key ORDER BY y DESC LIMIT 40) AS sq
                group by x, key order by y desc;", sep=" ")
              sql=gsub("\n"," ",sql_joined)
              rs <- try(dbSendQuery(dsccon, sql))},
              
              client_addr_vs_rcode_accum_asn_all_nodes = {
              sql_joined <- paste("PREPARE", statementNm, all_nodes_prep,
                "SELECT dsc.ip2asn(xx) AS x, key, sum(y) as y FROM 
                 (SELECT key1::ipaddress AS xx, il.name AS key, sum(d.value)/$1 As y 
                  FROM dsc.data d, iana_lookup il 
                  WHERE server_id=$2 AND d.plot_id=$3 AND starttime>=$4 AND starttime<=$5
                  AND d.key1 ", skipped_sql,
                  "AND il.registry = 'rcode' AND d.key2::text = il.value::text
                  GROUP BY xx, key ORDER BY y DESC LIMIT 40) AS sq
                group by x, key order by y desc;", sep=" ")
             sql=gsub("\n"," ",sql_joined)
             rs <- try(dbSendQuery(dsccon, sql))},
 
             client_addr_vs_rcode_accum_bgpprefix = {
             sql_joined <- paste("PREPARE", statementNm, select_nodes_prep,
               "SELECT xx / dsc.ip2bgpprefix(xx) AS x, key, sum(y) as y FROM 
                (SELECT key1::ipaddress AS xx, il.name AS key, sum(d.value)/$1 As y 
                 FROM dsc.data d, iana_lookup il 
                 WHERE server_id=$2 AND d.plot_id=$3 AND starttime>=$4 AND starttime<=$5
                 AND d.key1", skipped_sql,
                 "AND il.registry = 'rcode' AND d.key2::text = il.value::text",
                 select_nodes_sql,
                 "GROUP BY xx, key ORDER BY y DESC LIMIT 40) AS sq
                group by x, key order by y desc;", sep=" ")
            sql=gsub("\n"," ",sql_joined)
            rs <- try(dbSendQuery(dsccon, sql))},
            
            client_addr_vs_rcode_accum_bgpprefix_all_nodes = {
            sql_joined <- paste("PREPARE", statementNm, all_nodes_prep,
              "SELECT xx / dsc.ip2bgpprefix(xx) AS x, key, sum(y) as y FROM 
               (SELECT key1::ipaddress AS xx, il.name AS key, sum(d.value)/$1 As y 
                FROM dsc.data d, iana_lookup il 
                WHERE server_id=$2 AND d.plot_id=$3 AND starttime>=$4 AND starttime<=$5
                AND d.key1", skipped_sql,
                  "AND il.registry = 'rcode' AND d.key2::text = il.value::text
                GROUP BY xx, key ORDER BY y DESC LIMIT 40) AS sq
                group by x, key order by y desc;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},

           client_subnet2_accum_asn = {
             sql_joined <- paste("PREPARE", statementNm, select_nodes_prep,
               "SELECT ip2asn(xx) AS x, key, sum(y) as y FROM
                 (SELECT key1::ipaddress AS xx, key2 AS key, sum(value)/$1 AS y
                  FROM dsc.data 
                  WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5",
                  select_nodes_sql,
                  "AND key1", skipped_sql,
                  "GROUP BY xx, key ORDER BY y DESC LIMIT 40) AS sq
                group by x, key order by y desc;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},
           
           client_subnet2_accum_asn_all_nodes = {
             sql_joined <- paste("PREPARE", statementNm, all_nodes_prep,
               "SELECT ip2asn(xx) AS x, key, sum(y) as y FROM
                 (SELECT key1::ipaddress AS xx, key2 AS key, sum(value)/$1 AS y
                  FROM dsc.data 
                  WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5",
                  "AND key1", skipped_sql,
                  "GROUP BY xx, key ORDER BY y DESC LIMIT 40) AS sq
                group by x, key order by y desc;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},

           client_subnet2_accum_bgpprefix = {
             sql_joined <- paste("PREPARE", statementNm, select_nodes_prep,
               "SELECT xx / dsc.ip2bgpprefix(xx) AS x, key, sum(y) as y FROM
                 (SELECT key1::ipaddress AS xx, key2 AS key, sum(value)/$1 AS y
                  FROM dsc.data 
                  WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5",
                  select_nodes_sql,
                  "AND key1", skipped_sql,
                  "GROUP BY xx, key ORDER BY y DESC LIMIT 40) AS sq
                group by x, key order by y desc;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},
           
           client_subnet2_accum_bgpprefix_all_nodes = {
             sql_joined <- paste("PREPARE", statementNm, all_nodes_prep,
               "SELECT xx / dsc.ip2bgpprefix(xx) AS x, key, sum(y) as y FROM
                 (SELECT key1::ipaddress AS xx, key2 AS key, sum(value)/$1 AS y
                  FROM dsc.data 
                  WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5",
                  "AND key1", skipped_sql,
                  "GROUP BY xx, key ORDER BY y DESC LIMIT 40) AS sq
                group by x, key order by y desc;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},               

           server_addr = {
             sql_joined <- paste("PREPARE", statementNm, "(INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS",
               "select to_timestamp((extract(epoch from sq.sx)::int /
                 (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*
                 (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x,
                sq.skey as key, avg(sq.sy) as y from
                  (SELECT d.starttime AS sx, d.key1 AS skey, sum(d.value)/60.0 AS sy
                   FROM dsc.data d
                   WHERE d.server_id=$1
                    AND d.plot_id=$2 AND d.starttime>=$3 AND d.starttime<=$4
                    AND d.node_id = ANY (string_to_array($5, ',')::integer[])
                    AND (d.key1::ipaddress IN (SELECT address FROM service_addr WHERE server_id=$1) OR (SELECT count(*) FROM service_addr WHERE server_id=$1) = 0)
                   GROUP BY sx, skey) as sq
                GROUP BY x, key;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},


           server_addr_all_nodes = {
             sql_joined <- paste("PREPARE", statementNm, "(INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS",
             "select to_timestamp((extract(epoch from sq.sx)::int /
               (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int )*
               (extract(epoch from $4::timestamp - $3::timestamp + interval '1 minute')/1440)::int) AS x,
              sq.skey as key, avg(sq.sy) as y from
                (SELECT d.starttime AS sx, d.key1 AS skey,
                sum(d.value)/60.0 AS sy 
                FROM dsc.data d
                WHERE d.server_id=$1 AND d.plot_id=$2
                  AND d.starttime>=$3 AND d.starttime<=$4
                  AND (d.key1::ipaddress IN (SELECT address FROM service_addr WHERE server_id=$1) OR (SELECT count(*) FROM service_addr WHERE server_id=$1) = 0)
                GROUP BY sx, skey) as sq
              GROUP BY x, key;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},

           # client_subnet_vs_tld = {
           #   sql_joined <- paste("PREPARE", statementNm, "(REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS",
           #   "SELECT dsc.iptruncate(key1::ipaddress)::text AS x, key2 AS key, sum(value)/$1 As y
           #   FROM dsc.data
           #   WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5
           #     AND key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-')
           #     AND node_id = ANY (string_to_array($6, ',')::integer[])
           #     AND dsc.iptruncate(key1::ipaddress) IN
           #     (SELECT dsc.iptruncate(key1::ipaddress) AS k1
           #       FROM dsc.data
           #       WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4
           #       AND starttime<=$5 AND node_id = ANY (string_to_array($6, ',')::integer[])
           #       AND key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-')
           #       GROUP BY k1 ORDER BY sum(value)/$1 DESC LIMIT 40)
           #  GROUP BY x, key;", sep=" ")
           # sql=gsub("\n"," ",sql_joined)
           # rs <- try(dbSendQuery(dsccon, sql))},
           #
           # client_subnet_vs_tld_all_nodes = {
           #   sql_joined <- paste("PREPARE", statementNm, "(REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS",
           #   "SELECT dsc.iptruncate(key1::ipaddress)::text AS x, key2 AS key, sum(value)/$1 As y
           #   FROM dsc.data
           #   WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5
           #     AND key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-')
           #     AND dsc.iptruncate(key1::ipaddress) IN
           #     (SELECT dsc.iptruncate(key1::ipaddress) AS k1
           #       FROM dsc.data
           #       WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4
           #       AND starttime<=$5
           #       AND key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-')
           #     GROUP BY k1 ORDER BY sum(value)/$1 DESC LIMIT 40)
           #   GROUP BY x, key;", sep=" ")
           # sql=gsub("\n"," ",sql_joined)
           # rs <- try(dbSendQuery(dsccon, sql))},

           qtype_vs_tld = {
             sql_joined <- paste("PREPARE", statementNm, "(REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS",
             "SELECT lower(d.key1) AS x, CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS key, sum(d.value)/$1 AS y 
             FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key2::text = il.value::text AND il.registry = 'qtype'
             WHERE d.server_id=$2 AND d.plot_id=$3 AND d.starttime>=$4 AND d.starttime<=$5
               AND d.node_id = ANY (string_to_array($6, ',')::integer[])
               AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-')
               AND d.key1 IN
                 (SELECT key1
                   FROM dsc.data 
                   WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5
                   AND node_id = ANY (string_to_array($6, ',')::integer[])
                   AND key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
                   GROUP BY key1 ORDER BY sum(value)/$1 DESC LIMIT 40)
             GROUP BY x, key;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},

           qtype_vs_tld_all_nodes = {
             sql_joined <- paste("PREPARE", statementNm, "(REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS", 
             "SELECT lower(d.key1) AS x, CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS key, sum(d.value)/$1 AS y 
             FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key2::text = il.value::text AND il.registry = 'qtype'
             WHERE d.server_id=$2 AND d.plot_id=$3 AND d.starttime>=$4 AND d.starttime<=$5 
             AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') AND d.key1 IN
               (SELECT key1
                 FROM dsc.data 
                 WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5
                 AND key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-')
                 GROUP BY key1 ORDER BY sum(value)/$1 DESC LIMIT 40)
            GROUP BY x, key;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},

           qtype_vs_cctld = {
             sql_joined <- paste("PREPARE", statementNm, "(REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS",
             "SELECT alabel2ulabel(t.alabel) as x,
             CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS key, sum(d.value)/$1 AS y
             FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key2::text = il.value::text AND il.registry = 'qtype', tlds t
             where lower(d.key1) = lower(t.alabel) AND d.server_id=$2 AND d.plot_id=$3
             AND d.starttime>=$4 AND d.starttime<=$5 
             AND d.node_id = ANY (string_to_array($6, ',')::integer[]) 
             AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-')
             AND lower(d.key1) IN
               (SELECT lower(dd.key1)
                 FROM dsc.data dd LEFT OUTER JOIN tlds tt ON lower(dd.key1) = lower(tt.alabel) 
                   LEFT OUTER JOIN tld_types nn ON tt.type=nn.id 
                 WHERE nn.type_name='ccTLD' AND dd.server_id=$2 AND dd.plot_id=$3 
                 AND dd.starttime>=$4 AND dd.starttime<=$5
                 AND dd.node_id = ANY (string_to_array($6, ',')::integer[])
                 AND dd.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
                 GROUP BY lower(dd.key1)
                 ORDER BY sum(value)/$1 DESC LIMIT 40)
            GROUP BY x, key;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},

           qtype_vs_cctld_all_nodes = {
             sql_joined <- paste("PREPARE", statementNm, "(REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS",
             "SELECT alabel2ulabel(t.alabel) as x,
             CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS key, sum(d.value)/$1 AS y 
             FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key2::text = il.value::text AND il.registry = 'qtype', tlds t 
             where lower(d.key1) = lower(t.alabel) AND d.server_id=$2 AND d.plot_id=$3 
             AND d.starttime>=$4 AND d.starttime<=$5 
             AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-')
             AND lower(d.key1) IN 
               (SELECT lower(dd.key1)
               FROM dsc.data dd LEFT OUTER JOIN tlds tt ON lower(dd.key1) = lower(tt.alabel) 
                 LEFT OUTER JOIN tld_types nn ON tt.type=nn.id 
               WHERE nn.type_name='ccTLD' AND dd.server_id=$2 AND dd.plot_id=$3 
               AND dd.starttime>=$4 AND dd.starttime<=$5 
               AND dd.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
               GROUP BY lower(dd.key1) 
               ORDER BY sum(value)/$1 DESC LIMIT 40) 
            GROUP BY x, key;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},

           qtype_vs_newgtld = {
             sql_joined <- paste("PREPARE", statementNm, "(REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS",
             "SELECT alabel2ulabel(t.alabel) as x,
             CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS key, sum(d.value)/$1 AS y 
             FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key2::text = il.value::text AND il.registry = 'qtype', tlds t
             where lower(d.key1) = lower(t.alabel) AND d.server_id=$2 AND d.plot_id=$3 
             AND d.starttime>=$4 AND d.starttime<=$5 
             AND d.node_id = ANY (string_to_array($6, ',')::integer[]) 
             AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
             AND lower(d.key1) IN 
               (SELECT lower(dd.key1) 
                 FROM dsc.data dd LEFT OUTER JOIN tlds tt ON lower(dd.key1) = lower(tt.alabel) 
                 LEFT OUTER JOIN tld_types nn ON tt.type=nn.id 
                 WHERE nn.type_name='New-gTLD' AND dd.server_id=$2 AND dd.plot_id=$3 
                 AND dd.starttime>=$4 AND dd.starttime<=$5 
                 AND dd.node_id = ANY (string_to_array($6, ',')::integer[]) 
                 AND dd.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
                 GROUP BY lower(dd.key1) 
                 ORDER BY sum(value)/$1 DESC LIMIT 40) 
            GROUP BY x, key;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},

           qtype_vs_newgtld_all_nodes = {
             sql_joined <- paste("PREPARE", statementNm, "(REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS",
             "SELECT alabel2ulabel(t.alabel) as x,
             CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS key, sum(d.value)/$1 AS y 
             FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key2::text = il.value::text AND il.registry = 'qtype', tlds t 
             where lower(d.key1) = lower(t.alabel) AND d.server_id=$2 AND d.plot_id=$3 
             AND d.starttime>=$4 AND d.starttime<=$5 
             AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
             AND lower(d.key1) IN 
               (SELECT lower(dd.key1) 
               FROM dsc.data dd LEFT OUTER JOIN tlds tt ON lower(dd.key1) = lower(tt.alabel) 
               LEFT OUTER JOIN tld_types nn ON tt.type=nn.id 
               WHERE nn.type_name='New-gTLD' AND dd.server_id=$2 AND dd.plot_id=$3 
               AND dd.starttime>=$4 AND dd.starttime<=$5 
               AND dd.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
               GROUP BY lower(dd.key1) 
               ORDER BY sum(value)/$1 DESC LIMIT 40) 
            GROUP BY x, key;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},

           qtype_vs_legacygtld = {
             sql_joined <- paste("PREPARE", statementNm, "(REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS",
             "SELECT alabel2ulabel(t.alabel) as x, 
             CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS key, sum(d.value)/$1 AS y 
             FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key2::text = il.value::text AND il.registry = 'qtype', tlds t 
             where lower(d.key1) = lower(t.alabel) AND d.server_id=$2 AND d.plot_id=$3 
             AND d.starttime>=$4 AND d.starttime<=$5 
             AND d.node_id = ANY (string_to_array($6, ',')::integer[]) 
             AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
             AND lower(d.key1) IN 
               (SELECT lower(dd.key1) 
               FROM dsc.data dd LEFT OUTER JOIN tlds tt ON lower(dd.key1) = tt.alabel 
               LEFT OUTER JOIN tld_types nn ON tt.type=nn.id 
               WHERE nn.type_name='Legacy-gTLD' AND dd.server_id=$2 AND dd.plot_id=$3 
               AND dd.starttime>=$4 AND dd.starttime<=$5 
               AND dd.node_id = ANY (string_to_array($6, ',')::integer[]) 
               AND dd.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
               GROUP BY lower(dd.key1) ORDER BY sum(value)/$1 DESC LIMIT 40) 
            GROUP BY x, key;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},

           qtype_vs_legacygtld_all_nodes = {
             sql_joined <- paste("PREPARE", statementNm, "(REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS",
             "SELECT alabel2ulabel(t.alabel) as x,
             CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS key, sum(d.value)/$1 AS y 
             FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key2::text = il.value::text AND il.registry = 'qtype', tlds t 
             where lower(d.key1) = lower(t.alabel) AND d.server_id=$2 AND d.plot_id=$3 
             AND d.starttime>=$4 AND d.starttime<=$5 
             AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
             AND lower(d.key1) IN 
               (SELECT lower(dd.key1) 
               FROM dsc.data dd LEFT OUTER JOIN tlds tt ON lower(dd.key1) = lower(tt.alabel) 
               LEFT OUTER JOIN tld_types nn ON tt.type=nn.id 
               WHERE nn.type_name='Legacy-gTLD' AND dd.server_id=$2 AND dd.plot_id=$3 
               AND dd.starttime>=$4 AND dd.starttime<=$5 
               AND dd.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
               GROUP BY lower(dd.key1) 
               ORDER BY sum(value)/$1 DESC LIMIT 40) 
            GROUP BY x, key;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},

           qtype_vs_othertld = {
             sql_joined <- paste("PREPARE", statementNm, "(REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ, TEXT) AS",
             "SELECT alabel2ulabel(lower(d.key1)) AS x, CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS key, sum(d.value)/$1 AS y 
             FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key2::text = il.value::text AND il.registry = 'qtype'
             WHERE d.server_id=$2 AND d.plot_id=$3 AND d.starttime>=$4 AND d.starttime<=$5 
             AND d.node_id = ANY (string_to_array($6, ',')::integer[]) 
             AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
             AND lower(d.key1) IN 
               (SELECT lower(dd.key1) 
               FROM dsc.data dd LEFT OUTER JOIN tlds tt ON lower(dd.key1) = tt.alabel 
               LEFT OUTER JOIN tld_types nn ON tt.type=nn.id WHERE nn.type_name is NULL 
               AND dd.server_id=$2 AND dd.plot_id=$3 
               AND dd.starttime>=$4 AND dd.starttime<=$5 
               AND dd.node_id = ANY (string_to_array($6, ',')::integer[]) 
               AND dd.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
               GROUP BY lower(dd.key1) 
               ORDER BY sum(value)/$1 DESC LIMIT 40) 
            GROUP BY x, key;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},

           qtype_vs_othertld_all_nodes = {
             sql_joined <- paste("PREPARE", statementNm, "(REAL, INTEGER, INTEGER, TIMESTAMPTZ, TIMESTAMPTZ) AS",
             "SELECT alabel2ulabel(lower(d.key1)) AS x, CASE WHEN il.name IS NULL THEN 'Other' ELSE il.name END AS key, sum(d.value)/$1 AS y 
             FROM dsc.data d LEFT OUTER JOIN iana_lookup il ON d.key2::text = il.value::text AND il.registry = 'qtype'
             WHERE d.server_id=$2 AND d.plot_id=$3 AND d.starttime>=$4 AND d.starttime<=$5 
             AND d.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
             AND lower(d.key1) IN 
               (SELECT lower(dd.key1) 
               FROM dsc.data dd LEFT OUTER JOIN tlds tt ON lower(dd.key1) = lower(tt.alabel) 
               LEFT OUTER JOIN tld_types nn ON tt.type=nn.id WHERE nn.type_name is NULL 
               AND dd.server_id=$2 AND dd.plot_id=$3 
               AND dd.starttime>=$4 AND dd.starttime<=$5 
               AND dd.key1 NOT IN ('-:SKIPPED_SUM:-', '-:SKIPPED:-') 
               GROUP BY lower(dd.key1) 
               ORDER BY sum(value)/$1 DESC LIMIT 40) 
            GROUP BY x, key;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},

           dnskey_vs_asn = {
             sql_joined <- paste("PREPARE", statementNm, select_nodes_prep,
               "SELECT ip2asn(xx) AS x, key, sum(y) as y FROM
                 (SELECT key2::ipaddress AS xx, key1 AS key, sum(value)/$1 AS y
                  FROM dsc.data 
                  WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5",
                  select_nodes_sql,
                  "AND key2", skipped_sql, "AND key1='48'",
                  "GROUP BY xx, key ORDER BY y DESC LIMIT 40) AS sq
                group by x, key order by y desc;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},
           
           dnskey_vs_asn_all_nodes = {
             sql_joined <- paste("PREPARE", statementNm, all_nodes_prep,
               "SELECT ip2asn(xx) AS x, key, sum(y) as y FROM
                 (SELECT key2::ipaddress AS xx, key1 AS key, sum(value)/$1 AS y
                  FROM dsc.data 
                  WHERE server_id=$2 AND plot_id=$3 AND starttime>=$4 AND starttime<=$5",
                  "AND key2", skipped_sql, "AND key1='48'",
                  "GROUP BY xx, key ORDER BY y DESC LIMIT 40) AS sq
                group by x, key order by y desc;", sep=" ")
           sql=gsub("\n"," ",sql_joined)
           rs <- try(dbSendQuery(dsccon, sql))},


        )

        if(class(rs) == "try-error"){
            system(paste('logger -p user.crit database failed to load prepared statement name: "', statementNm, '" FROM dbconn.R', sep=""))
            return(FALSE)
        }else{
            return(TRUE)
        }
    }else{
        return(FALSE)
    }
}
