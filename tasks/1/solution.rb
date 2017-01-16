BOILING = {
  'water' => 100,
  'ethanol' => 78.37,
  'gold' => 2700,
  'silver' => 2162,
  'copper' => 2567
}
MELTING = {
  'water' => 0,
  'ethanol' => -114,
  'gold' => 1064,
  'silver' => 961.8,
  'copper' => 1085,
}
def to_celsius(degrees, from)
  case from
  when 'C' then degrees
  when 'K' then degrees - 273.15
  when 'F' then (degrees - 32) / 1.8
  end
end

def from_celsius(degrees, to)
  case to
  when 'C' then degrees
  when 'K' then degrees + 273.15
  when 'F' then degrees * 1.8 + 32
  end
end

def convert_between_temperature_units(degrees, from, to)
  degrees_in_celsius = to_celsius(degrees, from)
  from_celsius(degrees_in_celsius, to)
end

def boiling_point_of_substance(substance, type_of_deg)
  convert_between_temperature_units(BOILING[substance], 'C', type_of_deg)
end

def melting_point_of_substance(substance, type_of_deg)
  convert_between_temperature_units(MELTING[substance], 'C', type_of_deg)
end
