ActiveAdmin.register Profile do
  config.comments = false
end

ActiveAdmin.register ContractorProfile do
  config.comments = false
  menu :parent => "Profiles"
end

ActiveAdmin.register DeveloperProfile do
  config.comments = false
  menu :parent => "Profiles"
end
