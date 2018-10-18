note
	description: "Summary description for {PDF_ARRAY}."

class
	PDF_ARRAY

inherit
	PDF_OBJECT [ARRAYED_LIST [PDF_OBJECT [detachable ANY]]]
		rename
			value as items
		redefine
			default_create
		end

create
	default_create,
	make_with_objects,
	make_with_indirects,
	make_with_obj_refs

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			make_with_objects (<<>>)
		end

	make_with_objects (a_objects: ARRAY [PDF_OBJECT [detachable ANY]])
			-- `make_with_objects' in list `a_objects'.
		do
			create items.make_from_array (a_objects)
		end

	make_with_indirects (a_objects: ARRAY [PDF_INDIRECT_OBJECT])
			-- `make_with_objects' in list `a_objects'.
		do
			create items.make_from_array (a_objects)
		end

	make_with_obj_refs (a_refs: ARRAY [PDF_OBJECT_REFERENCE])
			--
		do
			create items.make_from_array (a_refs)
		end

feature -- Settings

	add_item (a_item: PDF_OBJECT [detachable ANY])
			--
		do
			check has_items: attached items as al_items then
				al_items.force (a_item)
			end
		end

feature -- Output

	pdf_out: STRING
		do
			create Result.make_empty
			Result.append_character ('[')
			if attached items as al_items then
				across
					al_items as ic
				loop
					Result.append_string_general (ic.item.pdf_out)
					if not al_items.islast then
						Result.append_character (' ')
					end
				end
				Result.adjust
			end
			Result.append_character (']')
			Result.adjust
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := left_square_bracket.out end
	closing_delimiter: STRING once ("OBJECT") Result := right_square_bracket.out end

;note
	specification: "ISO 32000-1, section 7.3.6 Array Objects"
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
