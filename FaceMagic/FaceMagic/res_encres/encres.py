#! /usr/bin/python

import os

for root, dirs, files in os.walk("shader_unenc"):
    for dir in dirs:
        dest_dir = 'shader' + os.path.join(root, dir)[12:]
        try:
            os.makedirs(dest_dir)
        except:
            pass
    for file in files:
        source_file = os.path.join(root, file)
        dest_file = 'shader' + source_file[12:]
        j = 0
        key = 'BE6CC4F5-40F7-4705-B0E5-E9BEC1C14735'
        source_f = open(source_file)
        dest_f = open(dest_file, 'wb')
        for c in source_f.read():
            if j == len(key):
                j = 0
            c = ord(c) ^ ord(key[j])
            dest_f.write(chr(c))
            j = j + 1
        source_f.close()
        dest_f.close()

"""
for root, dirs, files in os.walk("shader"):
    for file in files:
        print file
        ssss = ''
        source_file = os.path.join(root, file)
        j = 0
        key = 'BE6CC4F5-40F7-4705-B0E5-E9BEC1C14735'
        source_f = open(source_file)
        for c in source_f.read():
            if j == len(key):
                j = 0
            c = ord(c) ^ ord(key[j])
            ssss += chr(c)
            j = j + 1
        source_f.close()
        print ssss
"""
