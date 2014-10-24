#!/usr/bin/env python

import os
import sys
import yaml
from subprocess import call

# output files
POSTGRES_CONF = os.getenv('POSTGRES_CONF',
    '/etc/postgresql/9.3/main/postgresql.conf')
POSTGRES_HBA_CONF = os.getenv('POSTGRES_HBA_CONF',
    '/etc/postgresql/9.3/main/pg_hba.conf')
DB_CONFIG_SQL = os.getenv('DB_CONFIG_SQL', '/src/config.sql')
MERGED_CONFIG_YML = os.getenv('MERGED_CONFIG_YML', '/src/config.yml')

def config_merge(default, user):
    extensions = default.get('extensions')
    if 'extensions' in user:
	extensions += user.get('extensions')
	extensions = list(set(extensions))
    return dict(default.items() + user.items() + [('extensions', extensions)])

# default settings
DEFAULT_CONFIG = os.getenv('DEFAULT_CONFIG', '/src/default-config.yml')
if len(sys.argv) > 1:
    DEFAULT_CONFIG = sys.argv.pop(1)
    print 'DEFAULT', DEFAULT_CONFIG

# image specific settings
IMAGE_CONFIG = os.getenv('IMAGE_CONFIG', '/src/image-config.yml')
if len(sys.argv) > 1:
    IMAGE_CONFIG = sys.argv.pop(1)

with open(DEFAULT_CONFIG) as f:
    config = yaml.load(f)

with open(IMAGE_CONFIG) as f:
    image_config = yaml.load(f)
    if image_config:
	config = config_merge(config, image_config)
    # Make sure `name` and `role` are specified in the config.
    # If a key is missing, `KeyError:` exception would be raised
    config['name'] + config['role']

print yaml.dump({'Applying the merged config': config}, default_flow_style=False)

# Write the merged config
with open(MERGED_CONFIG_YML, 'w') as merged_conf:
    merged_conf.write(yaml.dump(config, default_flow_style=False))

# Update postgres listen address
call(['sed', '-i', POSTGRES_CONF, '-e',
    "s/^#listen_addresses = 'localhost'/listen_addresses = '%s'/" % config['listen-addr']])

# Whitelist 
with open(POSTGRES_HBA_CONF, 'a') as hba_conf:
    hba_conf.write('host %s %s 0.0.0.0/0 trust\n' % (config['name'], config['role']))

# Generate DB config SQL file: -create the db, the role, the extensions, etc
with open(DB_CONFIG_SQL, 'w') as db_conf:
    lines = [
	'CREATE ROLE %s WITH LOGIN;\n' % config['role'],
	'CREATE DATABASE %s;\n' % config['name'],
	'GRANT ALL PRIVILEGES ON DATABASE %s TO %s;\n' %
	    (config['name'], config['role']),
	'\c %s;\n' % config['name'],
    ] + list('CREATE EXTENSION IF NOT EXISTS %s;\n' % e for e in config['extensions'])

    for l in lines:
	db_conf.write(l)
