module ApplicationHelper
	def link_to_add_fields(name, f, type)
	  new_object = f.object.send "build_#{type}"
	  id = "new_#{type}"
	  fields = f.send("#{type}_fields", new_object, child_index: id) do |builder|
		render("#{type}_fields", f: builder)
	  end
      link_to(raw(name), '#', class: "add_fields btn-floating green", data: {id: id, fields: fields.gsub("\n", "")})
	end
end
