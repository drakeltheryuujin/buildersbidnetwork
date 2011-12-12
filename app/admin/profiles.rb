ActiveAdmin.register Profile do
  
end

ActiveAdmin.register ContractorProfile do
  menu :parent => "Profiles"
end

ActiveAdmin.register DeveloperProfile do
  menu :parent => "Profiles"
end
