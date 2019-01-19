note
	title: "Representation of a {PDF_ARRAY}."
	EIS: "name=7.3.6 Array Objects", "protocol=URI", "src=https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/PDF32000_2008.pdf#page=26&view=FitH", "override=true"
	description: "[
		An array object is a one-dimensional collection of objects arranged sequentially. Unlike arrays in many other
		computer languages, PDF arrays may be heterogeneous; that is, an array’s elements may be any combination
		of numbers, strings, dictionaries, or any other objects, including other arrays. An array may have zero
		elements.
		]"

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
			-- `make_with_objects' of empty-set.
		do
			Precursor
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
			-- `make_with_obj_refs' in `a_refs' array into `items' of Current.
		do
			create items.make_from_array (a_refs)
		end

feature -- Settings

	add_item (a_item: PDF_OBJECT [detachable ANY])
			-- `add_item' of `a_item' to `items' of Current.
		do
			check has_items: attached items as al_items then
				al_items.force (a_item)
			end
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
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

end
