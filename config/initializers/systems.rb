SYSTEMS_CONFIG = YAML.load_file("#{Rails.root}/config/systems.yml")[Rails.env]

TWIKI_USERNAME = SYSTEMS_CONFIG['twiki']['username']
TWIKI_PASSWORD = SYSTEMS_CONFIG['twiki']['password']
TWIKI_URL = SYSTEMS_CONFIG['twiki']['url']

