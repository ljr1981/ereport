note
	description: "Summary description for {PDF_STREAM_TABLE}."

class
	PDF_STREAM_TABLE

create
	default_create,
	make

feature {NONE} -- Initialization

	make (a_row_count, a_col_count: INTEGER)
			--
		do
			row_count := a_row_count
			col_count := a_col_count
		end

feature -- Access

	table: FW_ARRAY2_EXT [PDF_STREAM_ENTRY]
			-- `table' of Current.
		attribute
			create Result.make_filled (default_entry, row_count, col_count)
		end

	linked: LINKED_LIST [PDF_STREAM_ENTRY]
		do
			create Result.make
			across
				table as ic
			loop
				Result.force (ic.item)
			end
		end

	row_count: INTEGER

	col_count: INTEGER

	default_entry: PDF_STREAM_ENTRY
			--
		attribute
			create Result.make_with_font (create {PDF_FONT}.make ("Fx"))
		end

	x,
	y: INTEGER

feature -- Settings

	set_default_entry (a_entry: like default_entry)
			--
		require
			has_font_name: not a_entry.font_name.is_empty
		do
			default_entry := a_entry
		end

end
