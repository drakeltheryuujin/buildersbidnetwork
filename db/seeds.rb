# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

["Acoustic Treatment",
"Architectural Services",
"Audio Visual Equipment",
"Carpentry",
"CCTV Systems",
"Ceilings",
"Central Alarm and Detection Systems",
"Communications Cabling",
"Decorative Metal",
"Demolition",
"Doors and Frames",
"Electrical",
"Electrical Power Generation Equipment (Solar, Cogeneration)",
"Excavation",
"Fire Protection Engineering Services",
"Fire Supression",
"Flooring ",
"Furniture",
"Glazing",
"General Contracting",
"Heating Ventilating and Air Conditioning (HVAC)",
"Integrated Automation Facility Controls",
"Irrigation",
"Landscaping",
"Mechanical Engineering Services",
"Metal Decking",
"Metal Fabrications (stairs, railings, etc)",
"Painting and Coating",
"Paving",
"Plumbing",
"Roofing",
"Scaffolding",
"Site & Property Surveying / Soil, Concrete Testing",
"Skylight",
"Structural Engineering Services",
"Structural Repairs",
"Temporary Facilities and Controls",
"Tiling",
"Vertical Transportation",
"Wall Finishes",
"Waste Removal & Carting",
"Water Treatment ",
"Waterproofing",
"Weather Barriers",
"Windows"].each do |t|
  ProjectType.find_or_create_by_type_name(t)
end

["Office", "Fax", "Mobile", "Home"].each do |t|
  PhoneType.find_or_create_by_name(t)
end
