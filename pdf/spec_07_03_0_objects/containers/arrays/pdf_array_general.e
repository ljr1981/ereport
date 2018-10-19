note
	description: "General array of {PDF_OBJECT} items"

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
			-- `add_item' of `a_item' to `items' hash.
		do
			items_attached.force (a_item, a_item.out.hash_code)
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
					Result.append_character (' ')
				end
				Result.adjust
			end
			Result.append_character (']')
			Result.adjust
		end

feature {NONE} -- Implementation: Anchors

	items_anchor: detachable G
			-- Type anchor for items in `items'.

	items_attached: attached like items
			-- Attached version of `items'.
		do
			check attached items as al_items then Result := al_items end
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := left_square_bracket.out end
	closing_delimiter: STRING once ("OBJECT") Result := right_square_bracket.out end

;end
