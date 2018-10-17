note
	description: "Summary description for {PDF_PAGES}."

class
	PDF_PAGES

inherit
	PDF_INDIRECT_OBJECT

create
	make,
	make_with_kids

feature {NONE} -- Initialization

	make
			--
		do
			make_with_kids (<<>>)
		end

	make_with_kids (a_kids: ARRAY [PDF_OBJECT_REFERENCE])
			--
		do
			create dictionary

			create count.make_as_integer ("Count", a_kids.count)
			dictionary.add_object (count)

			default_create

			create type.make_as_name ("Type", "Pages")
			dictionary.add_object (type)

			create kids.make_as_array ("Kids", create {PDF_ARRAY}.make_with_obj_refs (a_kids))
			check attached {PDF_ARRAY} kids.value as al_kids and then attached {ARRAYED_LIST [PDF_OBJECT [detachable ANY]]} al_kids.items as al_items then
				across
					al_items as ic_kids
				loop
					check has: attached {PDF_OBJECT_REFERENCE} ic_kids.item as al_item then
						al_item.set_parent_ref (ref)
					end
				end
			end
			dictionary.add_object (kids)

			add_object (dictionary)
		end

feature -- Access

	dictionary: PDF_DICTIONARY

	type: PDF_KEY_VALUE

	kids: PDF_KEY_VALUE

	count: PDF_KEY_VALUE

end
