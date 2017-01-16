def convert_between_temperature_units(deg, from, to)
  deg += 273.15 if from == 'C' && to == 'K'
  deg if from == to
  deg = (deg * 1.8) + 32 if from == 'C' && to == 'F'
  deg -= 273.15 if from == 'K' && to == 'C'
  deg = (deg * 1.8) - 459.67 if from == 'K' && to == 'F'
  deg = (deg - 32) * 0.55555555555 if from == 'F' && to == 'C'
  deg = (deg + 459.67) * 0.55555555555 if from == 'F' && to == 'K'
  deg
end
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
def boiling_point_of_substance(substance, type_of_deg)
  convert_between_temperature_units(BOILING[substance], 'C', type_of_deg)
end
def melting_point_of_substance(substance, type_of_deg)
  convert_between_temperature_units(MELTING[substance], 'C', type_of_deg)
end
