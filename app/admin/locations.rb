ActiveAdmin.register Location do
  menu false

  sidebar :map do
    image_tag "http://maps.google.com/maps/api/staticmap?size=240x240&sensor=false&zoom=16&markers=#{location.latitude}%2C#{location.longitude}"
  end
end
