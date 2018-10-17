note
	description: "Summary description for {PDF_ARRAY_GENERAL}."

deferred class
	PDF_ARRAY_GENERAL [G -> PDF_OBJECT [detachable ANY]]

inherit
	PDF_OBJECT [HASH_TABLE [G, INTEGER]]
		rename
			value as items
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			Precursor
			create items.make (10)
		end

feature -- Settings

	add_item (a_item: G)
			--
		do
			items_attached.force (a_item, a_item.out.hash_code)
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
					Result.append_character (' ')
				end
			end
			Result.append_character (']')
		end

feature {NONE} -- Implementation: Anchors

	items_anchor: detachable G

	items_attached: attached like items
			--
		do
			check attached items as al_items then Result := al_items end
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := left_square_bracket.out end
	closing_delimiter: STRING once ("OBJECT") Result := right_square_bracket.out end

;end
