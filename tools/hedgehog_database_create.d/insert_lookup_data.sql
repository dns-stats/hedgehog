/* 
 * Copyright 2014 Internet Corporation for Assigned Names and Numbers.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Developed by Sinodun IT (www.sinodun.com)
 */


/* In 2.0 version 7 is used for backwards compatibility  */
INSERT INTO dsc.version (version) VALUES 
    (7);

INSERT INTO dsc.internal_version ( serial, script, description, applied ) VALUES
    (7, '-', 'DB creation', now() );

INSERT INTO dataset (name) VALUES ('certain_qnames_vs_qtype');
INSERT INTO dataset (name) VALUES ('chaos_types_and_names');
INSERT INTO dataset (name) VALUES ('client_addr_vs_rcode_accum');
INSERT INTO dataset (name) VALUES ('client_subnet2_accum');
INSERT INTO dataset (name) VALUES ('client_subnet2_count');
INSERT INTO dataset (name) VALUES ('client_subnet2_trace');
INSERT INTO dataset (name) VALUES ('client_subnet_accum');
INSERT INTO dataset (name) VALUES ('client_subnet_count');
INSERT INTO dataset (name) VALUES ('direction_vs_ipproto');
INSERT INTO dataset (name) VALUES ('dns_ip_version');
INSERT INTO dataset (name) VALUES ('dns_ip_version_vs_qtype');
INSERT INTO dataset (name) VALUES ('dnssec_qtype');
INSERT INTO dataset (name) VALUES ('do_bit');
INSERT INTO dataset (name) VALUES ('edns_version');
INSERT INTO dataset (name) VALUES ('idn_qname');
INSERT INTO dataset (name) VALUES ('idn_vs_tld');
INSERT INTO dataset (name) VALUES ('ipv6_rsn_abusers_accum');
INSERT INTO dataset (name) VALUES ('ipv6_rsn_abusers_count');
INSERT INTO dataset (name) VALUES ('opcode');
INSERT INTO dataset (name) VALUES ('pcap_stats');
INSERT INTO dataset (name) VALUES ('qtype');
INSERT INTO dataset (name) VALUES ('qtype_vs_qnamelen');
INSERT INTO dataset (name) VALUES ('qtype_vs_tld');
INSERT INTO dataset (name) VALUES ('rcode');
INSERT INTO dataset (name) VALUES ('rcode_vs_replylen');
INSERT INTO dataset (name) VALUES ('rd_bit');
INSERT INTO dataset (name) VALUES ('traffic_sizes_queries');
INSERT INTO dataset (name) VALUES ('traffic_sizes_responses');
INSERT INTO dataset (name) VALUES ('traffic_volume_queries');
INSERT INTO dataset (name) VALUES ('traffic_volume_responses');
INSERT INTO dataset (name) VALUES ('transport_vs_qtype');
INSERT INTO dataset (name) VALUES ('unique_sources');
INSERT INTO dataset (name) VALUES ('unique_sources_raw');

INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('by_node', '1.Node Statistics', 'By node', 'Queries by node');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('chaos_types_and_names', '2.Query Attributes', 'CHAOS queries', 'CHAOS queries');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('do_bit', '2.Query Attributes', 'DO bit', 'Queries with the DNSSEC OK bit set');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('edns_version', '2.Query Attributes', 'EDNS version', 'EDNS version');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('idn_qname', '2.Query Attributes', 'IDN qnames', 'Queries containing internationalized qnames');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('opcode', '2.Query Attributes', 'OPCODE', 'Breakdown of OPCODE values, other than QUERY');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('rd_bit', '2.Query Attributes', 'RD bit', 'Queries with Recursion Desired bit set');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('qtype', '3.QTYPE', 'DNS queries by QTYPE', 'QTYPE values in DNS queries');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('dnssec_qtype', '3.QTYPE', 'DNSSEC queries by QTYPE', 'QTYPE values in DNSSEC queries');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('certain_qnames_vs_qtype', '3.QTYPE', 'Popular query names by QTYPE', 'Queries for the name localhost and anything under root-servers.net.');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('qtype_vs_tld', '3.QTYPE', 'QTYPE for most popular TLDs', 'QTYPE values for most popular TLDs queried');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('qtype_vs_qnamelen', '3.QTYPE', 'Query name lengths by QTYPE', 'Query name lengths showing QTYPE');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('rcode', '4.RCODE', 'Replies by RCODE', 'RCODE values in DNS replies');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('rcode_vs_replylen', '4.RCODE', 'Reply lengths by RCODE (<1000 bytes)', 'Size of DNS replies showing RCODE for message size below 1000 bytes');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('rcode_vs_replylen_big', '4.RCODE', 'Reply lengths by RCODE (>=1000 bytes)', 'Size of DNS replies showing RCODE for message size above 1000 bytes');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('dns_ip_version', '5.IP Protocol', 'IP version', 'IP version carrying DNS queries');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('dns_ip_version_vs_qtype', '5.IP Protocol', 'Queries by IP version and QTYPE', 'QTYPE by IP version');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('direction_vs_ipproto', '5.IP Protocol', 'Received packets by IP protocol', 'Recieved Packets by IP protocol');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('transport_vs_qtype', '5.IP Protocol', 'Transports carrying DNS queries', 'Transports carrying DNS queries');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('pcap_stats', '6.PCAP Statistics', 'PCAP Statistics', 'Packet capture statistics');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('client_subnet_accum', '7.Client Subnet Statistics', 'Busiest client subnets', 'Busiest client subnets (IPv4/8 or IPv6/32)');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('client_addr_vs_rcode_accum', '7.Client Subnet Statistics', 'RCODE by client subnet', 'Busiest client subnets (IPv4/8 or IPv6/32) showing RCODE');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('ipv6_rsn_abusers_accum', '7.Client Subnet Statistics', 'Root abusers', 'Clients sending excessive root-servers.net queries');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('client_subnet2_accum', '8.Classification', 'Query classification by client subnet (accum)', 'Query classification by client subnet (IPv4/8 or IPv6/32)');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('client_subnet2_count', '8.Classification', 'Query classification by client subnet (count)', 'Count of client subnet sending each query classification');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('client_subnet2_trace', '8.Classification', 'Query classifications', 'Queries by classification');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('rcode_volume', '9.RSSAC', 'RCODE volume', 'Count of rcodes in responses');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('traffic_sizes_small', '9.RSSAC', 'Traffic sizes (<1000 bytes)', 'Histogram of DNS query and response sizes by transport for message size below 1000 bytes');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('traffic_sizes_big', '9.RSSAC', 'Traffic sizes (>=1000 bytes)', 'Histogram of DNS query and response sizes by transport for message size above 1000 bytes');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('traffic_volume', '9.RSSAC', 'Traffic volume', 'The number of queries and responses by transport and IP version');
INSERT INTO visible_plot (name, display_category, display_name, title) VALUES ('unique_sources', '9.RSSAC', 'Unique sources', 'The number of unique source addresses');

INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='by_node'), (SELECT id FROM dataset WHERE name='qtype'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='chaos_types_and_names'), (SELECT id FROM dataset WHERE name='chaos_types_and_names'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='do_bit'), (SELECT id FROM dataset WHERE name='do_bit'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='edns_version'), (SELECT id FROM dataset WHERE name='edns_version'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='idn_qname'), (SELECT id FROM dataset WHERE name='idn_qname'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='opcode'), (SELECT id FROM dataset WHERE name='opcode'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='rd_bit'), (SELECT id FROM dataset WHERE name='rd_bit'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='qtype'), (SELECT id FROM dataset WHERE name='qtype'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='dnssec_qtype'), (SELECT id FROM dataset WHERE name='dnssec_qtype'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='certain_qnames_vs_qtype'), (SELECT id FROM dataset WHERE name='certain_qnames_vs_qtype'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='qtype_vs_tld'), (SELECT id FROM dataset WHERE name='qtype_vs_tld'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='qtype_vs_qnamelen'), (SELECT id FROM dataset WHERE name='qtype_vs_qnamelen'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='rcode'), (SELECT id FROM dataset WHERE name='rcode'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='rcode_vs_replylen'), (SELECT id FROM dataset WHERE name='rcode_vs_replylen'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='rcode_vs_replylen_big'), (SELECT id FROM dataset WHERE name='rcode_vs_replylen'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='dns_ip_version'), (SELECT id FROM dataset WHERE name='dns_ip_version'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='dns_ip_version_vs_qtype'), (SELECT id FROM dataset WHERE name='dns_ip_version_vs_qtype'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='direction_vs_ipproto'), (SELECT id FROM dataset WHERE name='direction_vs_ipproto'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='transport_vs_qtype'), (SELECT id FROM dataset WHERE name='transport_vs_qtype'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='pcap_stats'), (SELECT id FROM dataset WHERE name='pcap_stats'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='client_subnet_accum'), (SELECT id FROM dataset WHERE name='client_subnet_accum'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='client_addr_vs_rcode_accum'), (SELECT id FROM dataset WHERE name='client_addr_vs_rcode_accum'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='ipv6_rsn_abusers_accum'), (SELECT id FROM dataset WHERE name='ipv6_rsn_abusers_accum'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='client_subnet2_accum'), (SELECT id FROM dataset WHERE name='client_subnet2_accum'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='client_subnet2_count'), (SELECT id FROM dataset WHERE name='client_subnet2_count'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='client_subnet2_trace'), (SELECT id FROM dataset WHERE name='client_subnet2_trace'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='rcode_volume'), (SELECT id FROM dataset WHERE name='rcode'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='traffic_sizes_small'), (SELECT id FROM dataset WHERE name='traffic_sizes_queries'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='traffic_sizes_small'), (SELECT id FROM dataset WHERE name='traffic_sizes_responses'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='traffic_sizes_big'), (SELECT id FROM dataset WHERE name='traffic_sizes_queries'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='traffic_sizes_big'), (SELECT id FROM dataset WHERE name='traffic_sizes_responses'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='traffic_volume'), (SELECT id FROM dataset WHERE name='traffic_volume_queries'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='traffic_volume'), (SELECT id FROM dataset WHERE name='traffic_volume_responses'));
INSERT INTO dataset_visible_plot (visible_plot_id, dataset_id) VALUES ((SELECT id from visible_plot where name='unique_sources'), (SELECT id FROM dataset WHERE name='unique_sources'));

INSERT INTO query_classification (name, title) VALUES ('Malformed', 'The DNS message was malformed and could not be entirely parsed');
INSERT INTO query_classification (name, title) VALUES ('Src port 0', 'The UDP query came from source port 0');
INSERT INTO query_classification (name, title) VALUES ('Funny Qtype', 'Query type was not one of the documented types');
INSERT INTO query_classification (name, title) VALUES ('Funny Qclass', 'Query class was not IN');
INSERT INTO query_classification (name, title) VALUES ('RFC1918PTR', 'The query type was PTR and the name was in an in-addr.arpa zone covered by RFC1918 private address space');
INSERT INTO query_classification (name, title) VALUES ('A-for-.', 'The query name was empty (equal to the root zone)');
INSERT INTO query_classification (name, title) VALUES ('A-for-A', 'The query name was already an IPv4 address');
INSERT INTO query_classification (name, title) VALUES ('localhost', 'The query was for localhost');
INSERT INTO query_classification (name, title) VALUES ('root-servers.net', 'The query was for a root-servers.net name');
INSERT INTO query_classification (name, title) VALUES ('Non-Authoritative TLD', ' The query was for a known-invalid TLD');
INSERT INTO query_classification (name, title) VALUES ('Unclassified', 'the query did not fall INTO one of the other categories');


INSERT INTO dsc.geo(name,country_code) values
    ('Afghanistan','AF'),
    ('Albania','AL'),
    ('Antarctica','AQ'),
    ('Algeria','DZ'),
    ('American Samoa','AS'),
    ('Andorra','AD'),
    ('Angola','AO'),
    ('Antigua and Barbuda','AG'),
    ('Azerbaijan','AZ'),
    ('Argentina','AR'),
    ('Australia','AU'),
    ('Austria','AT'),
    ('The Bahamas','BS'),
    ('Bahrain','BH'),
    ('Bangladesh','BD'),
    ('Armenia','AM'),
    ('Barbados','BB'),
    ('Belgium','BE'),
    ('Bhutan','BT'),
    ('Bolivia','BO'),
    ('Bosnia and Herzegovina','BA'),
    ('Botswana','BW'),
    ('Brazil','BR'),
    ('Belize','BZ'),
    ('Solomon Islands','SB'),
    ('Brunei Darussalam','BN'),
    ('Bulgaria','BG'),
    ('Burundi','BI'),
    ('Belarus','BY'),
    ('Cambodia','KH'),
    ('Cameroon','CM'),
    ('Canada','CA'),
    ('Cape Verde','CV'),
    ('Central African Republic','CF'),
    ('Sri Lanka','LK'),
    ('Chad','TD'),
    ('Chile','CL'),
    ('China','CN'),
    ('Christmas Island','CX'),
    ('Cocos (Keeling) Islands','CC'),
    ('Colombia','CO'),
    ('Comoros','KM'),
    ('Congo','CG'),
    ('Democratic Republic of the Congo','CD'),
    ('Cook Islands','CK'),
    ('Costa Rica','CR'),
    ('Croatia','HR'),
    ('Cyprus','CY'),
    ('Czech Republic','CZ'),
    ('Benin','BJ'),
    ('Denmark','DK'),
    ('Dominica','DM'),
    ('Dominican Republic','DO'),
    ('Ecuador','EC'),
    ('El Salvador','SV'),
    ('Equatorial Guinea','GQ'),
    ('Ethiopia','ET'),
    ('Eritrea','ER'),
    ('Estonia','EE'),
    ('South Georgia and the South Sandwich Islands','GS'),
    ('Fiji','FJ'),
    ('Finland','FI'),
    ('France','FR'),
    ('French Polynesia','PF'),
    ('French Southern and Antarctic Lands','TF'),
    ('Djibouti','DJ'),
    ('Gabon','GA'),
    ('Georgia','GE'),
    ('The Gambia','GM'),
    ('Germany','DE'),
    ('Ghana','GH'),
    ('Kiribati','KI'),
    ('Greece','GR'),
    ('Grenada','GD'),
    ('Guam','GU'),
    ('Guatemala','GT'),
    ('Guinea','GN'),
    ('Guyana','GY'),
    ('Haiti','HT'),
    ('Heard Island and McDonald Islands','HM'),
    ('Vatican City','VA'),
    ('Honduras','HN'),
    ('Hungary','HU'),
    ('Iceland','IS'),
    ('India','IN'),
    ('Indonesia','ID'),
    ('Iraq','IQ'),
    ('Ireland','IE'),
    ('Israel','IL'),
    ('Italy','IT'),
    ('Cote d''Ivoire','CI'),
    ('Jamaica','JM'),
    ('Japan','JP'),
    ('Kazakhstan','KZ'),
    ('Jordan','JO'),
    ('Kenya','KE'),
    ('South Korea','KR'),
    ('Kuwait','KW'),
    ('Kyrgyzstan','KG'),
    ('Laos','LA'),
    ('Lebanon','LB'),
    ('Lesotho','LS'),
    ('Latvia','LV'),
    ('Liberia','LR'),
    ('Libya','LY'),
    ('Liechtenstein','LI'),
    ('Lithuania','LT'),
    ('Luxembourg','LU'),
    ('Madagascar','MG'),
    ('Malawi','MW'),
    ('Malaysia','MY'),
    ('Maldives','MV'),
    ('Mali','ML'),
    ('Malta','MT'),
    ('Mauritania','MR'),
    ('Mauritius','MU'),
    ('Mexico','MX'),
    ('Monaco','MC'),
    ('Mongolia','MN'),
    ('Moldova','MD'),
    ('Montenegro','ME'),
    ('Morocco','MA'),
    ('Mozambique','MZ'),
    ('Oman','OM'),
    ('Namibia','NA'),
    ('Nauru','NR'),
    ('Nepal','NP'),
    ('Netherlands','NL'),
    ('New Caledonia','NC'),
    ('Vanuatu','VU'),
    ('New Zealand','NZ'),
    ('Nicaragua','NI'),
    ('Niger','NE'),
    ('Nigeria','NG'),
    ('Niue','NU'),
    ('Norfolk Island','NF'),
    ('Norway','NO'),
    ('Northern Mariana Islands','MP'),
    ('United States Minor Outlying Islands','UM'),
    ('Micronesia','FM'),
    ('Marshall Islands','MH'),
    ('Palau','PW'),
    ('Pakistan','PK'),
    ('Panama','PA'),
    ('Papua New Guinea','PG'),
    ('Paraguay','PY'),
    ('Peru','PE'),
    ('Philippines','PH'),
    ('Pitcairn Islands','PN'),
    ('Poland','PL'),
    ('Portugal','PT'),
    ('Guinea-Bissau','GW'),
    ('Timor-Leste','TL'),
    ('Qatar','QA'),
    ('Romania','RO'),
    ('Russia','RU'),
    ('Rwanda','RW'),
    ('Saint Helena','SH'),
    ('Saint Kitts and Nevis','KN'),
    ('Saint Lucia','LC'),
    ('Saint Pierre and Miquelon','PM'),
    ('Saint Vincent and the Grenadines','VC'),
    ('San Marino','SM'),
    ('Sao Tome and Principe','ST'),
    ('Saudi Arabia','SA'),
    ('Senegal','SN'),
    ('Serbia','RS'),
    ('Seychelles','SC'),
    ('Sierra Leone','SL'),
    ('Singapore','SG'),
    ('Slovakia','SK'),
    ('Vietnam','VN'),
    ('Slovenia','SI'),
    ('Somalia','SO'),
    ('South Africa','ZA'),
    ('Zimbabwe','ZW'),
    ('Spain','ES'),
    ('Suriname','SR'),
    ('Swaziland','SZ'),
    ('Sweden','SE'),
    ('Switzerland','CH'),
    ('Tajikistan','TJ'),
    ('Thailand','TH'),
    ('Togo','TG'),
    ('Tokelau','TK'),
    ('Tonga','TO'),
    ('Trinidad and Tobago','TT'),
    ('United Arab Emirates','AE'),
    ('Tunisia','TN'),
    ('Turkey','TR'),
    ('Turkmenistan','TM'),
    ('Tuvalu','TV'),
    ('Uganda','UG'),
    ('Ukraine','UA'),
    ('Macedonia (FYROM)','MK'),
    ('Egypt','EG'),
    ('United Kingdom','GB'),
    ('Tanzania','TZ'),
    ('United States','US'),
    ('Burkina Faso','BF'),
    ('Uruguay','UY'),
    ('Uzbekistan','UZ'),
    ('Venezuela','VE'),
    ('Wallis and Futuna','WF'),
    ('Samoa','WS'),
    ('Yemen','YE'),
    ('Zambia','ZM');

INSERT INTO dsc.iana_lookup (registry,value,name,description) values
    ('IP', 1, 'ICMP', 'Internet Control Message'),
    ('IP', 6, 'TCP', 'Transmission Control'),
    ('IP', 17, 'UDP', 'User Datagram'),
    ('IP', 58, 'IPv6-ICMP', 'ICMP for IPv6');

INSERT INTO dsc.iana_lookup (registry,value,name,description) values
    ('DNS CLASS', 0, 'Reserved', 'Reserved'),
    ('DNS CLASS', 1, 'IN', 'Internet'),
    ('DNS CLASS', 2, 'Unassigned', 'Unassigned'),
    ('DNS CLASS', 3, 'CH', 'Chaos'),
    ('DNS CLASS', 4, 'HS', 'Hesiod'),
    ('DNS CLASS', 254, 'QCLASS NONE', 'QCLASS NONE'),
    ('DNS CLASS', 4, 'ANY', 'QCLASS *'),
    ('DNS CLASS', 65535, 'Reserved', 'Reserved');

INSERT INTO dsc.iana_lookup (registry,value,name,description) values
    ('qtype', 1, 'A', 'a host address'),
    ('qtype', 2, 'NS', 'an authoritative name server'),
    ('qtype', 3, 'MD', 'a mail destination (OBSOLETE - use MX)'),
    ('qtype', 4, 'MF', 'a mail forwarder (OBSOLETE - use MX)'),
    ('qtype', 5, 'CNAME', 'the canonical name for an alias'),
    ('qtype', 6, 'SOA', 'marks the start of a zone of authority'),
    ('qtype', 7, 'MB', 'a mailbox domain name (EXPERIMENTAL)'),
    ('qtype', 8, 'MG', 'a mail group member (EXPERIMENTAL)'),
    ('qtype', 9, 'MR', 'a mail rename domain name (EXPERIMENTAL)'),
    ('qtype', 10, 'NULL', 'a null RR (EXPERIMENTAL)'),
    ('qtype', 11, 'WKS', 'a well known service description'),
    ('qtype', 12, 'PTR', 'a domain name pointer'),
    ('qtype', 13, 'HINFO', 'host information'),
    ('qtype', 14, 'MINFO', 'mailbox or mail list information'),
    ('qtype', 15, 'MX', 'mail exchange'),
    ('qtype', 16, 'TXT', 'text strings'),
    ('qtype', 17, 'RP', 'for Responsible Person'),
    ('qtype', 18, 'AFSDB', 'for AFS Data Base location'),
    ('qtype', 19, 'X25', 'for X.25 PSDN address'),
    ('qtype', 20, 'ISDN', 'for ISDN address'),
    ('qtype', 21, 'RT', 'for Route Through'),
    ('qtype', 22, 'NSAP', 'for NSAP address, NSAP style A record'),
    ('qtype', 23, 'NSAP-PTR', 'for domain name pointer, NSAP style'),
    ('qtype', 24, 'SIG', 'for security signature'),
    ('qtype', 25, 'KEY', 'for security key'),
    ('dnssec_qtype', 25, 'KEY', 'for security key'),
    ('qtype', 26, 'PX', 'fX.400 mail mapping information'),
    ('qtype', 27, 'GPOS', 'Geographical Position'),
    ('qtype', 28, 'AAAA', 'IP6 Address'),
    ('qtype', 29, 'LOC', 'Location Information'),
    ('qtype', 30, 'NXT', 'Next Domain (OBSOLETE)'),
    ('qtype', 31, 'EID', 'Endpoint Identifier'),
    ('qtype', 32, 'NIMLOC', 'Nimrod Locator'),
    ('qtype', 33, 'SRV', 'Server Selection'),
    ('qtype', 34, 'ATMA', 'ATM Address'),
    ('qtype', 35, 'NAPTR', 'Naming Authority Pointer'),
    ('qtype', 36, 'KX', 'Key Exchanger'),
    ('qtype', 37, 'CERT', 'CERT'),
    ('qtype', 38, 'A6', 'A6 (OBSOLETE - use AAAA)'),
    ('qtype', 39, 'DNAME', 'DNAME'),
    ('qtype', 40, 'SINK', 'SINK'),
    ('qtype', 41, 'OPT', 'OPT'),
    ('qtype', 42, 'APL', 'APL'),
    ('qtype', 43, 'DS', 'Delegation Signer'),
    ('dnssec_qtype', 43, 'DS', 'Delegation Signer'),
    ('qtype', 44, 'SSHFP', 'SSH Key Fingerprint'),
    ('qtype', 45, 'IPSECKEY', 'IPSECKEY'),
    ('qtype', 46, 'RRSIG', 'RRSIG'),
    ('dnssec_qtype', 46, 'RRSIG', 'RRSIG'),
    ('qtype', 47, 'NSEC', 'NSEC'),
    ('dnssec_qtype', 47, 'NSEC', 'NSEC'),
    ('qtype', 48, 'DNSKEY', 'DNSKEY'),
    ('dnssec_qtype', 48, 'DNSKEY', 'DNSKEY'),
    ('qtype', 49, 'DHCID', 'DHCID'),
    ('qtype', 50, 'NSEC3', 'NSEC3'),
    ('dnssec_qtype', 50, 'NSEC3', 'NSEC3'),
    ('qtype', 51, 'NSEC3PARAM', 'NSEC3PARAM'),
    ('dnssec_qtype', 51, 'NSEC3PARAM', 'NSEC3PARAM'),
    ('qtype', 52, 'TLSA', 'TLSA'),
    ('qtype', 55, 'HIP', 'Host Identity Protocol'),
    ('qtype', 56, 'NINFO', 'NINFO'),
    ('qtype', 57, 'RKEY', 'RKEY'),
    ('qtype', 58, 'TALINK', 'Trust Anchor LINK'),
    ('qtype', 59, 'CDS', 'Child DS'),
    ('qtype', 99, 'SPF', NULL),
    ('qtype', 100, 'UINFO', NULL),
    ('qtype', 101, 'UID', NULL),
    ('qtype', 102, 'GID', NULL),
    ('qtype', 103, 'UNSPEC', NULL),
    ('qtype', 104, 'NID', NULL),
    ('qtype', 105, 'L32', NULL),
    ('qtype', 106, 'L64', NULL),
    ('qtype', 107, 'LP', NULL),
    ('qtype', 249, 'TKEY', 'Transaction Key'),
    ('qtype', 250, 'TSIG', 'Transaction Signature'),
    ('qtype', 251, 'IXFR', 'incremental transfer'),
    ('qtype', 252, 'AXFR', 'transfer of an entire zone'),
    ('qtype', 253, 'MAILB', 'mailbox-related RRs (MB, MG or MR)'),
    ('qtype', 254, 'MAILA', 'mail agent RRs (OBSOLETE - see MX)'),
    ('qtype', 255, 'ANY', 'A request for all records'),
    ('qtype', 256, 'URI', 'URI'),
    ('qtype', 257, 'CAA', 'Certification Authority Authorization'),
    ('qtype', 32768, 'TA', 'DNSSEC Trust Authorities'),
    ('qtype', 32769, 'DLV', 'DNSSEC Lookaside Validation'),
    ('qtype', 65535, 'Reserved', NULL);

INSERT INTO dsc.iana_lookup (registry,value,name,description) values
    ('opcode', 0, 'Query', NULL),
    ('opcode', 1, 'IQuery', '(Inverse Query, OBSOLETE)'),
    ('opcode', 2, 'Status', NULL),
    ('opcode', 3, 'Unassigned', NULL),
    ('opcode', 4, 'Notify', NULL),
    ('opcode', 5, 'Update', NULL);

INSERT INTO dsc.iana_lookup (registry,value,name,description) values
    ('rcode', 0, 'NoError', 'No Error'),
    ('rcode', 1, 'FormErr', 'Format Error'),
    ('rcode', 2, 'ServFail', 'Server Failure'),
    ('rcode', 3, 'NXDomain', 'Non-Existent Domain'),
    ('rcode', 4, 'NotImp', 'Not Implemented'),
    ('rcode', 5, 'Refused', 'Query Refused'),
    ('rcode', 6, 'YXDomain', 'Name Exists when it should not'),
    ('rcode', 7, 'YXRRSet', 'RR Set Exists when it should not'),
    ('rcode', 8, 'NXRRSet', 'RR Set that should exist does not'),
    ('rcode', 9, 'NotAuth', 'Server Not Authoritative for zone'),
    ('rcode', 10, 'NotZone', 'Name not contained in zone'),
    ('rcode', 16, 'BADVERS', 'Bad OPT Version'),
    ('rcode', 17, 'BADKEY', 'Key not recognized'),
    ('rcode', 18, 'BADTIME', 'Signature out of time window'),
    ('rcode', 19, 'BADMODE', 'Bad TKEY Mode'),
    ('rcode', 20, 'BADNAME', 'Duplicate key name'),
    ('rcode', 21, 'BADALG', 'Algorithm not supported'),
    ('rcode', 22, 'BADTRUNC', 'Bad Truncation'),
    ('rcode', 65535, 'Reserved', 'Reserved, can be allocated by Standards Action');

INSERT INTO dsc.iana_lookup (registry,value,name,description) values
    ('DNS EDNS0 Options', 0, 'Reserved', NULL),
    ('DNS EDNS0 Options', 1, 'LLQ', 'On-hold'),
    ('DNS EDNS0 Options', 2, 'UL', 'On-hold'),
    ('DNS EDNS0 Options', 3, 'NSID', 'Standard'),
    ('DNS EDNS0 Options', 4, 'Reserved', NULL);

-- Fill in the blanks
INSERT INTO dsc.iana_lookup
(
SELECT 'DNS CLASS' AS registry, v AS value, 'Unassigned' AS name
FROM generate_series(5,253) as v
);

INSERT INTO dsc.iana_lookup
(
SELECT 'DNS CLASS' AS registry, v AS value, 'Unassigned' AS name
FROM generate_series(256,65279) as v
);

INSERT INTO dsc.iana_lookup
(
SELECT 'DNS CLASS' AS registry, v AS value, 'Reserved for Private Use' AS name
FROM generate_series(65280,65534) as v
);

INSERT INTO dsc.iana_lookup
(
SELECT 'qtype' AS registry, v AS value, 'Unassigned' AS name
FROM generate_series(53,54) as v
);

INSERT INTO dsc.iana_lookup
(
SELECT 'qtype' AS registry, v AS value, 'Unassigned' AS name
FROM generate_series(60,98) as v
);

INSERT INTO dsc.iana_lookup
(
SELECT 'qtype' AS registry, v AS value, 'Unassigned' AS name
FROM generate_series(108,248) as v
);

INSERT INTO dsc.iana_lookup
(
SELECT 'qtype' AS registry, v AS value, 'Unassigned' AS name
FROM generate_series(258,32767) as v
);

INSERT INTO dsc.iana_lookup
(
SELECT 'qtype' AS registry, v AS value, 'Unassigned' AS name
FROM generate_series(32770,65279) as v
);

INSERT INTO dsc.iana_lookup
(
SELECT 'qtype' AS registry, v AS value, 'Reserved for Private Use' AS name
FROM generate_series(65280,65534) as v
);

INSERT INTO dsc.iana_lookup
(
SELECT 'opcode' AS registry, v AS value, 'Unassigned' AS name
FROM generate_series(6,15) as v
);

INSERT INTO dsc.iana_lookup
(
SELECT 'rcode' AS registry, v AS value, 'Unassigned' AS name
FROM generate_series(11,15) as v
);

INSERT INTO dsc.iana_lookup
(
SELECT 'rcode' AS registry, v AS value, 'Unassigned' AS name
FROM generate_series(23,3840) as v
);

INSERT INTO dsc.iana_lookup
(
SELECT 'rcode' AS registry, v AS value, 'Reserved for Private Use' AS name
FROM generate_series(3841,4095) as v
);

INSERT INTO dsc.iana_lookup
(
SELECT 'rcode' AS registry, v AS value, 'Unassigned' AS name
FROM generate_series(4096,65534) as v
);

INSERT INTO dsc.iana_lookup
(
SELECT 'DNS EDNS0 Options' AS registry, v AS value, 'Unassigned' AS name
FROM generate_series(5,65534) as v
);

-- These are flags - not sure where I am going to put them.
/*
INSERT INTO dsc.iana_lookup (registry,value,name,description) values
    ('DNS Header Flags', 5, 'AA', 'Authoritative Answer'),
    ('DNS Header Flags', 6, 'TC', 'Truncated Response'),
    ('DNS Header Flags', 7, 'RD', 'Recursion Desired'),
    ('DNS Header Flags', 8, 'RA', 'Recursion Allowed'),
    ('DNS Header Flags', 9, 'Reserved', 'Reserved'),
    ('DNS Header Flags', 10, 'AD', 'Authentic Data'),
    ('DNS Header Flags', 11, 'CD', 'Checking Disabled');

INSERT INTO dsc.iana_lookup (registry,value,name,description) values ('EDNS Header Flags', 0, 'DO', 'DNSSEC answer OK');
INSERT INTO dsc.iana_lookup
(
SELECT 'EDNS Header Flags' AS registry, v AS value, 'Reserved' AS name
FROM generate_series(5,65534) as v
);

 INSERT INTO dsc.iana_lookup (registry,value,name,description) values ('EDNS version Number', 0, 'EDNS version 0', 'EDNS version 0');
INSERT INTO dsc.iana_lookup
(
SELECT 'EDNS version Number' AS registry, v AS value, 'Unassigned' AS name
FROM generate_series(5,65534) as v
);
*/
