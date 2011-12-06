module SearchHelper
  def search_path(search, opts = {})
    path = {
      "search[q]" => opts[:q] || @search.q, 
      "search[section]" => opts[:section] || @search.section, 
      "search[order]" => opts[:order] || @search.order
    }
    path["search[location]"] = @search.location unless @search.location.blank?
    path["search[distance]"] = @search.distance unless @search.distance.blank?
    path["search[type_ids]"] = @search.type_ids unless @search.type_ids.blank? 

    search_index_path(path)
  end
end
