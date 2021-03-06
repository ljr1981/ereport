note
	description: "Representation of a {PDF_STREAM_TABLE}."

class
	PDF_STREAM_TABLE

create
	default_create,
	make

feature {NONE} -- Initialization

	make (a_column_count: INTEGER;
			a_contents: ARRAY [STRING];
			a_entry_basis: detachable like entry_basis;
			a_media_box: PDF_MEDIA_BOX)
			--
		local
			l_entries: ARRAYED_LIST [PDF_STREAM_ENTRY]
			l_entry: like entry_basis
		do
			if attached a_entry_basis as al_entry_basis then
				entry_basis := al_entry_basis
				create table.make_filled (al_entry_basis, 1, a_column_count)
			else
				create table.make_filled (entry_basis, 1, a_column_count)
			end
			media_box := a_media_box
			across
				a_contents as ic
			from
				create l_entries.make (a_contents.count)
			loop
				l_entry := entry_basis.twin
				l_entry.set_tj_text (ic.item)
				l_entries.force (l_entry)
			end
			table.put_by_row (l_entries.to_array, 1)
		end

feature -- Access

	table: FW_ARRAY2_EXT [PDF_STREAM_ENTRY]
			-- `table' of Current.
		attribute
			create Result.make_filled (entry_basis, row_count, column_count)
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
			-- `row_count' of `table'.
		do
			Result := table.row_count
		end

	column_count: INTEGER
			-- `column_count' of `table'.
		do
			Result := table.column_count
		end

	entry_basis: PDF_STREAM_ENTRY
			--
		attribute
			create Result.make_with_font (create {PDF_FONT}.make ("Fx"))
		end

	media_box: PDF_MEDIA_BOX
			-- `media_box' of Current.
		attribute
			create Result
			Result.set_portrait
		end

	generate_pages_and_streams (a_left, a_top, a_right, a_bottom: INTEGER)
			--
		local
			l_positions: attached like positions_list_anchor
			l_page: PDF_PAGE_US
			l_stream: PDF_STREAM_PLAIN_TEXT_OBJECT

			l_page_count,
			l_last_page_no,
			l_row, l_col: INTEGER

			l_entries: ARRAYED_LIST [TUPLE [tf_font_name: STRING_8; tf_font_size: INTEGER_32; td_x: INTEGER_32; td_y: INTEGER_32; tj_text: STRING_8]]
			l_posn_item: TUPLE [x: INTEGER_32; x_right: INTEGER_32; y: INTEGER_32; page: INTEGER_32; row: INTEGER_32]
			l_move: TUPLE [x, y: INTEGER]
			l_last_move: detachable TUPLE [x, y: INTEGER]
		do
			l_positions := positions_list_with_margins (a_left, a_top, a_right, a_bottom)
			l_page_count := page_count_of_positions_list (l_positions)
			across
				1 |..| l_positions.count as ici
			from
				l_row := 1
				l_col := 1
				l_last_page_no := 1
				create l_entries.make (l_positions.row_count * l_positions.column_count)
			loop
				l_posn_item := l_positions.item (l_row, l_col)

				check has_posn_item: attached l_posn_item as al_posn_item then
					-------------------------------------------------------
					if al_posn_item.page > l_last_page_no then 	-- we have new page
					-------------------------------------------------------
							-- create the new stream obj with l_list entries
						create l_stream.make_with_entries (l_entries.to_array)
							-- put that stream into streams hash
						streams.force (l_stream, l_last_page_no)
							-- create the new page obj with the stream obj
						create l_page.make_with_contents (l_stream.ref, fonts_hash_to_array)
							-- put that page into the pages hash
						pages.force (l_page, l_last_page_no)
							-- create a new list
						create l_entries.make (l_positions.row_count * l_positions.column_count)

							-- take us to the next page
						l_last_page_no := al_posn_item.page
						check valid_page_no: l_last_page_no <= l_page_count end
						check has_stream_at_cursor_index: attached stream_entries [ici.item] as al_entry then
							l_move := entry_moves (Void, [l_posn_item.x, l_posn_item.y], True)
							l_entries.force ([al_entry.tf_font_ref_name, al_entry.tf_font_size, l_move.x, l_move.y, al_entry.tj_text])
							l_last_move := l_move.twin
						end
					-------------------------------------------------------
					else 	-- we are on the current page (l_last_page_no)
					-------------------------------------------------------
							-- get the matching stream_entries object
							-- put it in the list
						check has_stream_at_cursor_index: attached stream_entries [ici.item] as al_entry then
							l_move := entry_moves (l_last_move, [l_posn_item.x, l_posn_item.y], l_col = 1)
							l_entries.force ([al_entry.tf_font_ref_name, al_entry.tf_font_size, l_move.x, l_move.y, al_entry.tj_text])
							l_last_move := l_move.twin
						end
					end
				end

					-- Handle row/col counts
				l_col := l_col + 1
				if l_col > l_positions.column_count then
					l_col := 1
					l_row := l_row + 1
				end
			end
		end

	entry_moves (a_last: detachable TUPLE [x, y: INTEGER]; a_this: TUPLE [x, y: INTEGER]; a_is_BOL: BOOLEAN): TUPLE [x_move, y_move: INTEGER]
			-- What is the move to get from entry-A to entry-B?
			-- BOL = Beginning of Line
		do
			if a_last = Void then
				Result := [0, 0]
			elseif attached a_last as al_last then
				Result := [a_this.x - al_last.x, 0]
			elseif attached a_last as al_last and then a_is_BOL then
				Result := [0, al_last.y - a_this.y]
			else
				Result := [0, 0]
				check unknown_case: False end
			end
		end

	page_count_of_positions_list (a_list: attached like positions_list_anchor): INTEGER
			-- A `page_count_of_positions_list' in `a_list' like `positions_list_anchor'.
		do
			check has_item: attached a_list.item (a_list.row_count, a_list.column_count) as al_item then
				Result := al_item.page
			end
		end

	positions_list_with_margins (a_left, a_top, a_right, a_bottom: INTEGER): attached like positions_list_anchor
			-- Version of `positions' list with adjustments for "margins"
			--	left, top, right, and bottom,
			--	where a [0 + left, 0, 0 + top] = new page
		note
			design: "[
				Each result item has its [x,y] position for a continuous single "logical" page.
				
				Each result item also has its far-rightmost position.
				
				Finally, each result item has its "physical" page number and row 
				within that "physical" page.
				]"
		local
			l_x_scalar: REAL_64
			l_x, l_x_right,
			l_y,
			l_y_offset, l_y_max,
			l_row, l_col: INTEGER
		do
			across
				positions_list as ic
			from
				create Result.make_filled ([0, 0, 0, 0, 0], row_count, column_count)
				l_x_scalar := (media_box.bounds.urx - a_left - a_right) / media_box.bounds.urx
				l_row := 1; l_col := 1
				l_y_offset := 0
				l_y_max := (media_box.bounds.ury - a_top - a_bottom)
			loop
				check has_item: attached ic.item as al_item then
					l_x := (al_item.x * l_x_scalar).truncated_to_integer + a_left
					l_x_right := (al_item.x_right * l_x_scalar).truncated_to_integer + a_left
					l_y_offset := (al_item.y // l_y_max) * l_y_max
					l_y := al_item.y + a_top
					Result.put ([l_x, l_x_right, l_y, page_number (al_item.y, l_y_max), l_row], l_row, l_col)
				end

					-- Trace row/column
				l_col := l_col + 1
				if l_col > column_count then
					l_col := 1
					l_row := l_row + 1
				end
			end
		ensure
			valid_count: Result.count = positions_list.count
		end

	page_number (a_current_y, a_max_y: INTEGER): INTEGER
			-- The `page_number', given `a_current_y' position on a logical "page"
			--	and then `a_max_y' for a physical page (including removal of top
			--	and bottom margins).
		do
			Result := (a_current_y // a_max_y) + 1
		end

	positions_list: attached like positions_list_anchor
			-- Raw [x, x_right, y] positions with point-of-view of
			--	one continuous logical page and a width of `media_box.bounds.urx'.
			--  No margins or page borders applied (yet).
		note
			design: "[
				In a page agnostic way, starting at the upper-left
				corner of a logical (not physical) "page", lay out
				the contents of Current (i.e. column_x_positions and
				row_y_positions).
				
				See `column_x_positions' and `row_y_positions' for more.
				]"
		require
			rows_and_columns: row_count > 0 and then column_count > 0
		local
			x, y: INTEGER
			l_x_posns: like column_x_positions
			l_y_posns: like row_y_positions
		do
			l_x_posns := column_x_positions
			l_y_posns := row_y_positions
			across
				l_y_posns as icy
			from
				create Result.make_filled ([0, 0, 0, 0, 0], row_count, column_count)
			loop
				y := icy.cursor_index
				across
					l_x_posns as icx
				loop
					x := icx.cursor_index
					check has_icx_item: attached icx.item as al_icx_item
						attached al_icx_item.x as col_x_left and then
						attached al_icx_item.x_right as col_x_right and then
						attached icy.item as row_y
					then
						Result.force ([col_x_left, col_x_right, row_y, 0, 0], y, x)
					end
				end
			end
		ensure
			posn_each_item: Result.count = table.count implies Result.count = (row_count * column_count)
			positive: across Result as ic all
									attached ic.item as al_item and then
									(al_item.x >= 0 and then
									al_item.x <= media_box.bounds.urx and then
									al_item.y >= 0)
								end
		end

	is_page_room_remaining (a_max, a_used, a_y: INTEGER): BOOLEAN
			-- Given `a_max' page size and `a_used' y-value, and current `a_y' need,
			-- 	is there any remaining y-room on the current page?
		do
			Result := (a_max - a_used) >= a_y
		end

	column_x_positions: ARRAY [detachable TUPLE [x, x_right: INTEGER]]
			-- The "x-axis" positions of columns going across the logical page.
		note
			design: "[
				VARIANTS
				========
				Justified - Column-x positions evenly spread over page width.
				Max-width - Starting far left, each column starts at end of max-width
							of the last column (i.e. col-n starts at col-n - 1 end + gutter width)
				]"
			glossary: "[
				Logical Page - the abstract notion of a page, but not physical pages
								(either on paper or some display).
				Physical Page - the concrete notion of a page, either on paper or some dispaly.
				]"
		local
			i,
			x, x_right: INTEGER
		do
			create Result.make_filled ([0, 0], 1, column_count)
			if column_count > 1 then
					-- left x positions
				across
					1 |..| (column_count - 1) as ic
				from
					x := ((media_box.bounds.urx - media_box.bounds.llx) / column_count).truncated_to_integer
				loop
					Result.put ([x * ic.item, x_right], ic.item + 1)
				end
					-- x_right gutter positions
				across
					1 |..| (column_count - 1) as ic
				loop
					i := ic.item
					if attached Result [i] as al_left_item and then attached Result [i + 1] as al_right_item then
						al_left_item.x_right := al_right_item.x - Default_gutter_width
					elseif attached Result [i] as al_left_item then
						al_left_item.x_right := media_box.bounds.urx - Default_gutter_width
					else
						check unknown_condition: False end
					end
					if i + 1 = column_count and then attached Result [i + 1] as al_right_item then
						al_right_item.x_right := media_box.bounds.urx - Default_gutter_width
					end
				end
			end
		ensure
			valid_count: Result.count = column_count
			first_zero: attached Result [1] as al and then al.x = 0
			positive: across Result as ic all attached ic.item as al_item and then
						al_item.x >= 0 end
			in_bounds_1: Result.count >= 1 implies
						attached Result [1] as al_1 and then
						al_1.x >= 0 and then
						al_1.x <= al_1.x_right
			in_bounds_2: Result.count >= 2 implies
						across 1 |..| (Result.count - 1) as ic all
							attached ic.item as n and then
							attached Result [n] as al_n1 and then
							attached Result [n + 1] as al_n2 and then
							al_n1.x >= 0 and then
							al_n1.x <= al_n1.x_right and then
							al_n1.x_right <= al_n2.x and then
							al_n2.x <= al_n2.x_right
						end
		end

	gutter_width: detachable INTEGER
			-- Client-settable value for `gutter_width'.
		attribute
			Result := default_gutter_width
		end

	gutter_width_attached: INTEGER
			-- Attached version of `gutter_width'.
		do
			check has_gutter: attached gutter_width as al_width then Result := al_width end
		end

	default_gutter_width: INTEGER = 5

	row_y_positions: ARRAY [INTEGER]
			-- The "y-axis" positions of rows going down the logical page.
		note
			design: "[
				Presume the top of the page starts at 0,0 in the upper-left corner.
				
				This will need to be transformed to the PDF coordinate system where
				the origin of the page is the lower-left. This library assumes a page
				that reads from top-to-bottom and left-to-right (i.e. not Hebrew or Chinese,
				but English or English-like).
				]"
			glossary: "[
				Logical Page - the abstract notion of a page, but not physical pages
								(either on paper or some display).
				Physical Page - the concrete notion of a page, either on paper or some dispaly.
				]"
		local
			l_row_max,
			l_last_y: INTEGER
		do
			create Result.make_filled (0, 1, row_count)
			across
				table.rows as ic_rows
			from
				l_last_y := 0
			loop
				l_last_y := l_last_y + max_height (ic_rows.item)
				Result.put (l_last_y, ic_rows.cursor_index)
			end
		ensure
			valid_count: Result.count = row_count
			positive: across Result as ic all ic.item >= 0 end
			in_bounds: Result.count >= 2 implies
						across 1 |..| (Result.count - 1) as ic all
							attached ic.item as n and then
							attached Result [n] as al_n and then
							attached Result [n + 1] as al_n2 and then
							al_n <= al_n2
						end
		end

	max_height (a_items: ARRAY [PDF_STREAM_ENTRY]): INTEGER
			-- What is the max "Tf_font_size" in `a_items' list?
		do
			across
				a_items as ic
			from
				Result := 0
			loop
				check valid_font_size: ic.item.Tf_font_size > 0 end
				if ic.item.Tf_font_size > Result then
					Result := ic.item.Tf_font_size
				end
			end
		ensure
			positive: Result >= 0
		end

feature -- Settings

	set_default_entry (a_entry: like entry_basis)
			--
		require
			has_font_name: not a_entry.font_name.is_empty
		do
			entry_basis := a_entry
		end

feature -- Output

	generate (a_last_font_number, a_last_page_number, a_last_stream_number: INTEGER)
			-- `generate' Current to `fonts', `pages', and `stream_entries'.
		local
			l_font_number: INTEGER
		do
				-- FONTS
			across
				table as ic_table
			from
				l_font_number := a_last_font_number + 1
			loop
				ic_table.item.font.set_object_number (l_font_number)
				l_font_number := l_font_number + 1
				fonts.force (ic_table.item.font, ic_table.item.font_basefont)
			end
				-- STREAMS
			across
				table as ic
			loop
				stream_entries.force (ic.item, ic.cursor_index)
			end
		end

feature {TEST_SET_BRIDGE} -- Implementation: Fonts, Pages, and Streams

	fonts: HASH_TABLE [PDF_FONT, STRING] -- str = font_basefont name
			-- Hash of `fonts' generated by `generate'.
		attribute
			create Result.make (1000)
		end

	pages: HASH_TABLE [PDF_PAGE_US, INTEGER] -- int = page#
			-- Hash of `pages' generated by `generate'.
		attribute
			create Result.make (1000)
		end

	streams: HASH_TABLE [PDF_STREAM_PLAIN_TEXT_OBJECT, INTEGER] -- int = related page#
			-- Hash of `streams' generated by ... ?
		attribute
			create Result.make (1000)
		end

	stream_entries: HASH_TABLE [PDF_STREAM_ENTRY, INTEGER] -- int = stream#
			-- Hash of `stream_entries' generated by `generate'.
		attribute
			create Result.make (1000)
		end

feature {NONE} -- Implementation: Type Anchors

	positions_list_anchor: detachable FW_ARRAY2_EXT [detachable TUPLE [x, x_right, y, page, row: INTEGER]]
			-- Type anchor for Result's like `positions_list'

feature {NONE} -- Implementation: Fonts, Streams, and Pages: Support

	fonts_hash_to_array: ARRAY [PDF_FONT]
			-- An ARRAY version of `fonts' hash.
		local
			l_result: ARRAYED_LIST [PDF_FONT]
		do
			create l_result.make (fonts.count)
			across
				fonts as ic
			loop
				l_result.force (ic.item)
			end
			Result := l_result.to_array
		end

	stream_obj: PDF_STREAM_PLAIN_TEXT_OBJECT
			-- A single `stream_obj' consisting of all `stream_entry_tuples'.
		do
			create Result.make_with_entries (stream_entry_tuples)
		end

	stream_entry_tuples: ARRAY [TUPLE [font_obj_number: STRING_8; Td_x_move, Td_y_move: INTEGER_32; Tf_font_size: INTEGER_32; Tj_text: STRING_8]]
			-- A TUPLE of Stream Entries (font#, x,y-move, font-size, text).
		local
			l_entries: ARRAYED_LIST [TUPLE [STRING_8, INTEGER_32, INTEGER_32, INTEGER_32, STRING_8]]
		do
			create l_entries.make (stream_entries.count)
			across
				stream_entries as ic
			loop
				l_entries.force ([ic.item.tf_font_ref_name, ic.item.tf_font_size, ic.item.td_x_move, ic.item.td_y_move, ic.item.tj_text])
			end
			Result := l_entries.to_array
		end

	stream_item (i: INTEGER): PDF_STREAM_ENTRY
			-- A particular `stream_item' of `stream_entries', entry item number `i'.
		do
			check has_i: attached stream_entries [i] as al_result then Result := al_result end
		end

note
	goal: "[
		Given a `table' (2-dim), generate the resulting:
		
		1. Font objects
		2. Pages objects
		3. Stream objects
		]"

end
