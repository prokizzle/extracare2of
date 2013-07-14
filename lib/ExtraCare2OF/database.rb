class ImportedDeals < ActiveYaml::Base
  set_root_path "../../db"
  set_filename "imported_deals"
  field :name, :due_date
end

class DealManager

def initialize
load
end

def exists?(name)
p ImportedDeals.find_by_name(name).count
end

def load
array = ImportedDeals.all
end

def save_deal(name, due)
array.push({name: name, due_date: due})
end

def save
ImportedDeals.data = array
end
end