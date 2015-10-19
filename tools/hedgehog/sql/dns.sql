/* 
 * Copyright 2015 Internet Corporation for Assigned Names and Numbers.
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

/* Take an IPv[46] address and look it up in the Team Cymru IP to ASN DNS service
 * See http://www.team-cymru.org/IP-ASN-mapping.html
 */

CREATE or REPLACE FUNCTION dsc.ip2asn (addr dsc.ipaddress)
  RETURNS text
as $$

  rdata = plpy.execute("select dsc.teamcymrulookup('" + addr + "')")
  if rdata != None:
    result = rdata[0]['teamcymrulookup']
    if result != None:
      return result.split('|')[0].strip()
          
  plpy.info('Function ip2asn: No ASN found')
  return None
$$ LANGUAGE plpythonu;

CREATE or REPLACE FUNCTION dsc.ip2bgpprefix (addr dsc.ipaddress)
  RETURNS int
as $$

  rdata = plpy.execute("select dsc.teamcymrulookup('" + addr + "')")
  if rdata != None:
    result = rdata[0]['teamcymrulookup']
    if result != None:
      bgpprefix = result.split('|')[1].strip()
      return int(bgpprefix.split('/')[1])
          
  plpy.info('Function ip2bgpprefix: No BGP Prefix found')
  return None
$$ LANGUAGE plpythonu;

CREATE or REPLACE FUNCTION dsc.teamcymrulookup (addr dsc.ipaddress)
  RETURNS text
as $$
  from IPy import IP
  import getdns
  
  ''' Sanity Check '''
  if addr is None:
    plpy.error('Function teamcymrulookup: Address passed in was null')
    return None
    
  ''' Create a IPy IP object '''
  ip = IP(addr)

  ''' reverse the address '''
  if ip.version() == 4:
    s = ip.strFullsize()
    s = s.split('.')
    s.reverse()
    s = '.'.join(s)
    qname = "%s.origin.asn.cymru.com." % s
  elif ip.version() == 6:
    s = '%032x' % ip.int()
    s = list(s)
    s.reverse()
    s = '.'.join(s)
    qname = "%s.origin6.asn.cymru.com." % s 
  else:
    plpy.error('Function teamcymrulookup: Unknown IP address type.')
    return None
    
  ''' Store/retrieve the context in/from the global dict. '''
  if 'teamcymrulookupctx' in GD.keys():
      ctx = GD['teamcymrulookupctx']
  else:
      ctx = getdns.Context()
      GD['teamcymrulookupctx'] = ctx
  ctx.resolution_type = getdns.RESOLUTION_STUB
  
  try:
    results = ctx.general(name=qname, request_type=getdns.RRTYPE_TXT, extensions={})
  except getdns.error as e:
    plpy.error('Function teamcymrulookup: GetDNS Error: %s' % str(e))
    return None
  status = results.status
  if status == getdns.RESPSTATUS_GOOD:
    for reply in results.replies_tree:
      answers = reply['answer']
      for answer in answers:
        if answer['type'] == getdns.RRTYPE_TXT:
          rdata = answer['rdata']
          return rdata['txt_strings'][0]
          
  plpy.info('Function teamcymrulookup: No data returned from DNS query')
  return None
$$ LANGUAGE plpythonu;