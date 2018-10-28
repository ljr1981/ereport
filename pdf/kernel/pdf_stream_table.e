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

	positions_list: FW_ARRAY2_EXT [detachable TUPLE [x, y: INTEGER]]
			-- Raw [x,y] positions with point-of-view of
			--	one continuous page, with a media_box.bounds.urx width.
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
			l_x_posns: like column_x_positions
			l_y_posns: like row_y_positions
		do
			l_x_posns := column_x_positions
			l_y_posns := row_y_positions
			across
				l_y_posns as icy
			from
				create Result.make_filled ([0, 0], row_count, column_count)
			loop
				across
					l_x_posns as icx
				loop
					check has_icx_item: attached icx.item as al_icx_item then
						Result.force ([al_icx_item.x, icy.item], icy.cursor_index, icx.cursor_index)
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
			-- The "x-axis" positions of columns of Current.
		note
			design: "[
				VARIANTS
				========
				Justified - Column-x positions evenly spread over page width.
				Max-width - Starting far left, each column starts at end of max-width
							of the last column (i.e. col-n starts at col-n - 1 end + gutter width)
				]"
		local
			i, i2,
			x, x_right: INTEGER
		do
			x := ((media_box.bounds.urx - media_box.bounds.llx) / column_count).truncated_to_integer
			create Result.make_filled ([0, 0], 1, column_count)
			if column_count > 1 then
				across
					1 |..| (column_count - 1) as ic
				loop
					Result.put ([x * ic.item, x_right], ic.item + 1)
				end
				across
					1 |..| (column_count - 1) as ic
				from
					i := 1; i2 := 2
				loop
					if attached Result [ic.item] as al_left_item and then attached Result [ic.item + 1] as al_right_item then
						al_left_item.x_right := (al_right_item.x - Default_gutter_width)
					elseif attached Result [ic.item] as al_left_item then
						al_left_item.x_right := (media_box.bounds.urx - Default_gutter_width)
					else
						check unknown_condition: False end
					end
				end
			end
		ensure
			Result.count = column_count
			Result [1] = 0
			across Result as ic all attached ic.item as al_item and then al_item.x >= 0 end
		end

	gutter_width: detachable INTEGER
	default_gutter_width: INTEGER = 5

	row_y_positions: ARRAY [INTEGER]
			--
		local
			l_row_max,
			l_last_y: INTEGER
		do
			create Result.make_filled (0, 1, row_count)
			if column_count > 1 then
				across
					table.rows as ic_rows
				from
					l_last_y := 0
				loop
					across
						ic_rows.item as ic
					from
						l_row_max := 0
					loop
						check valid_font_size: ic.item.Tf_font_size > 0 end
						if ic.item.Tf_font_size > l_row_max then
							l_row_max := ic.item.Tf_font_size
						end
					end
					l_last_y := l_last_y + l_row_max
					Result.put (l_last_y, ic_rows.cursor_index)
				end
			end
		ensure
			Result.count = row_count
			across Result as ic all ic.item >= 0 end
		end


	first_font_number,
	last_font_number: INTEGER

	first_page_number,
	last_page_number: INTEGER

	first_stream_number,
	last_stream_number: INTEGER

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
			-- `generate' Current to `fonts', `pages', and `streams'.
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
				streams.force (ic.item, ic.cursor_index)
			end
		end

feature {TEST_SET_BRIDGE} -- Implementation: Fonts, Pages, and Streams

	fonts: HASH_TABLE [PDF_FONT, STRING] -- str = font_basefont name
			-- `fonts' generated by `generate'.
		attribute
			create Result.make (10)
		end

	pages: HASH_TABLE [PDF_PAGE, INTEGER] -- int = page#
			-- `pages' generated by `generate'.
		attribute
			create Result.make (10)
		end

	streams: HASH_TABLE [PDF_STREAM_ENTRY, INTEGER] -- int = stream#
			-- `streams' generated by `generate'.
		attribute
			create Result.make (10)
		end

feature {NONE} -- Implementation: Fonts, Streams, and Pages: Support

	fonts_array: ARRAY [PDF_FONT]
			--
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
		do
			create Result.make_with_entries (stream_entries)
		end

	stream_entries: ARRAY [TUPLE [STRING_8, INTEGER_32, INTEGER_32, INTEGER_32, STRING_8]]
		local
			l_entries: ARRAYED_LIST [TUPLE [STRING_8, INTEGER_32, INTEGER_32, INTEGER_32, STRING_8]]
		do
			create l_entries.make (streams.count)
			across
				streams as ic
			loop
				l_entries.force ([ic.item.tf_font_ref_name, ic.item.tf_font_size, ic.item.td_x_move, ic.item.td_y_move, ic.item.tj_text])
			end
			Result := l_entries.to_array
		end

	stream_item (i: INTEGER): PDF_STREAM_ENTRY
		do
			check has_i: attached streams [i] as al_result then Result := al_result end
		end

note
	goal: "[
		Given a `table' (2-dim), generate the resulting:
		
		1. Font objects
		2. Pages objects
		3. Stream objects
		]"

end
