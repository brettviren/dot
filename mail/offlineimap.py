#!/usr/bin/env python
# Adapted from
# http://roland.entierement.nu/blog/2010/09/08/gnus-dovecot-offlineimap-search-a-howto.html

# Propagate gnus-expire flag
from offlineimap import imaputil

def lld_flagsimap2maildir(flagstring):
    flagmap = {'\\seen': 'S',
               '\\answered': 'R',
               '\\flagged': 'F',
               '\\deleted': 'T',
               '\\draft': 'D',
               'gnus-expire': 'E',
               'gnus-dormant': 'Q',
               'gnus-forward': 'W',
               'gnus-save': 'V',
               }
    retval = []
    imapflaglist = [x.lower() for x in flagstring[1:-1].split()]
    for imapflag in imapflaglist:
        if flagmap.has_key(imapflag):
            retval.append(flagmap[imapflag])
            pass
        continue
    retval.sort()
    return retval

def lld_flagsmaildir2imap(list):
    flagmap = {'S': '\\Seen',
               'R': '\\Answered',
               'F': '\\Flagged',
               'T': '\\Deleted',
               'D': '\\Draft',
               'E': 'gnus-expire',
               'Q': 'gnus-dormant',
               'W': 'gnus-forward',
               'V': 'gnus-save',
               }
    retval = []
    for mdflag in list:
        if flagmap.has_key(mdflag):
            retval.append(flagmap[mdflag])
            pass
        continue
    retval.sort()
    return '(' + ' '.join(retval) + ')'

imaputil.flagsmaildir2imap = lld_flagsmaildir2imap
imaputil.flagsimap2maildir = lld_flagsimap2maildir

# Grab some folders first, and archives later
high = ['^default$', '^dayabay']
low = ['^lists', '^.auto', '^.root']
import re

def lld_cmp(x, y):
    for r in high:
        xm = re.search (r, x)
        ym = re.search (r, y)
        if xm and ym:
            return cmp(x, y)
        elif xm:
            return -1
        elif ym:
            return +1
        continue
    for r in low:
        xm = re.search (r, x)
        ym = re.search (r, y)
        if xm and ym:
            return cmp(x, y)
        elif xm:
            return +1
        elif ym:
            return -1
        continue
    return cmp(x, y)

