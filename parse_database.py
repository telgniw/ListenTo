import sys

try:
    imagesDir, dbPath = sys.argv[1:]
except:
    print >> sys.stderr, 'usage:'
    print >> sys.stderr, '\t', sys.argv[0], '<dir-for-images>', '<db-path>'
    exit(1)

import os

files = [f for f in os.listdir(unicode(imagesDir))
    if os.path.isfile(os.path.join(imagesDir, f))]
files.sort(cmp=lambda x, y:cmp(int(x.split('.')[0]), int(y.split('.')[0])))

import sqlite3

conn = sqlite3.connect(dbPath)
c = conn.cursor()

c.execute("""
    CREATE TABLE Cards (
        id          INTEGER PRIMARY KEY,
        name        TEXT,
        image       TEXT,
        voice       TEXT
    )
""")
c.execute("""
    CREATE TABLE Records (
        id          INTEGER PRIMARY KEY,
        type        SHORT,
        timestamp   DATETIME DEFAULT CURRENT_TIMESTAMP
    )
""")
c.execute("""
    CREATE TABLE RecordDetails (
        id          INTEGER,
        cid_voice   INTEGER,
        cid_image   INTEGER,
        count       INTEGER,
        FOREIGN KEY (id) REFERENCES Records(id) ON DELETE CASCADE,
        FOREIGN KEY (cid_voice, cid_image) REFERENCES Cards(id, id)
    )
""")

for f in files:
    name = f.split('.')[1]
    c.execute("""
        INSERT INTO Cards (name, image) VALUES (?,?)
    """, (name, f))

conn.commit()
conn.close()
