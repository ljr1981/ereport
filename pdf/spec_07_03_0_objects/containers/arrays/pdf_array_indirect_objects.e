note
	description: "General array of {PDF_INDIRECT_OBJECT} items"

class
	PDF_ARRAY_INDIRECT_OBJECTS

inherit
	PDF_ARRAY_GENERAL [PDF_INDIRECT_OBJECT]
		redefine
			add_item
		end

feature -- Settings

	add_item (a_item: attached like items_anchor)
			-- <Precursor>
		do
			a_item.set_object_number (items_attached.count + 1)
			items_attached.force (a_item, a_item.out.hash_code)
		end

end
