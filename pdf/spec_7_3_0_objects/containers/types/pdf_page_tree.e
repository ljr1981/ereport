note
	description: "Representation of {PDF_PAGE_TREE}."

class
	PDF_PAGE_TREE

inherit
	PDF_INDIRECT_OBJECT

create
	make,
	make_with_kids

feature {NONE} -- Initialization

	make
			-- `make' Current with no `kids'.
		do
			make_with_kids (<<>>)
		end

	make_with_kids (a_kids: ARRAY [PDF_OBJECT_REFERENCE])
			-- `make_with_kids' (child PDF_PAGE items).
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
			-- `dictionary' for Current.

	type: PDF_KEY_VALUE
			-- /Type /Pages

	kids: PDF_KEY_VALUE
			-- `kids' (child pages). /Kids /[Array_of_kid_refs]

	count: PDF_KEY_VALUE
			-- `count' /Count /[Int_value] of `kids'.

;note
	main_spec: "7.7.3.2 Page Tree Nodes"
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
