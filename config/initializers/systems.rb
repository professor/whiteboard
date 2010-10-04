SYSTEMS_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/systems.yml")[RAILS_ENV]

TWIKI_USERNAME = SYSTEMS_CONFIG['twiki']['username']
TWIKI_PASSWORD = SYSTEMS_CONFIG['twiki']['password']
TWIKI_URL = SYSTEMS_CONFIG['twiki']['url']

