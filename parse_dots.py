#!/usr/env/bin python
import sys

try:
    rawFile, plist = sys.argv[1:]
except:
    print >> sys.stderr, 'usage:'
    print >> sys.stderr, '\t', sys.argv[0], '<raw-file>', '<output-plist>'

import codecs

with codecs.open(rawFile, 'r', encoding='utf-8') as fin:
    lines = fin.readlines()

coordinates = []
for line in lines:
    xi = line.find('X')
    x = int(line[xi+1:].split()[0])

    yi = line.find('Y')
    y = int(line[yi+1:].split()[0])

    coordinates.append({
        'x': x - 107,
        'y': y - 107
    })

def write_plist(fout, element, level):
    tabs = '\t' * level

    if type(element) == list:
        print >> fout, tabs + '<array>'
        
        for v in element:
            write_plist(fout, v, level+1)

        print >> fout, tabs + '</array>'
    elif type(element) == dict:
        print >> fout, tabs + '<dict>'

        for k, v in element.iteritems():
            print >> fout, tabs + '<key>%s</key>' % str(k)
            write_plist(fout, v, level+1)

        print >> fout, tabs + '</dict>'
    elif type(element) == int:
        print >> fout, tabs + '<integer>%d</integer>' % element

with open(plist, 'w') as fout:
    print >> fout, '<?xml version="1.0" encoding="UTF-8"?>'
    print >> fout, '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">'
    print >> fout, '<plist version="1.0">'

    write_plist(fout, coordinates, 0)

    print >> fout, '</plist>'
