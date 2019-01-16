note
	description: "Facilities of a {PDF_MEDIA_BOX}."

class
	PDF_MEDIA_BOX

feature -- Access: Items

	stream_entries: LINKED_LIST [PDF_STREAM_ENTRY]
			-- A list of media box `stream_entries'.
		attribute
			create Result.make
		end

feature -- Setters: Items

	add_item (a_item: PDF_STREAM_ENTRY; a_x, x_y: INTEGER; a_row, a_column: INTEGER)
			-- Add `a_item' to `stream_entries'.
		local
			l_last_item: PDF_STREAM_ENTRY
		do
			if attached stream_entries.last as al_last_item then
				a_item.give_same_coordinates (al_last_item)
			else
				move_to_top_left (a_item)
			end
			stream_entries.force (a_item)
		end

feature -- Access: MediaBox & Positioning

	bounds: TUPLE [llx, lly, urx, ury: INTEGER]
			-- MediaBox lower-left and upper-right bounds.
			-- Default to US 8 1/2 x 11 inch paper size.
		attribute
			if is_portrait then
				Result := [0, 0, page_x_width_us_8_x_11, page_y_height_us_8_x_11]
			else
				Result := [0, 0, page_y_height_us_8_x_11, page_x_width_us_8_x_11]
			end
		end

	is_portrait: BOOLEAN do Result := not is_landscape end
	is_landscape: BOOLEAN

	set_portrait do is_landscape := False ensure is_portrait end
	set_landscape do is_landscape := True ensure is_landscape end

	move_to_top_left (a_item: PDF_STREAM_ENTRY)
			-- Move coordinates of `a_item' to top-left
		do
			move_to_natural (a_item, 0, 0)
		end

	move_to_natural (a_item: PDF_STREAM_ENTRY; x, y: INTEGER)
			-- Presumes origin (0,0) = upper-left corner (vs lower-left corner).
			-- Therefore, we transform the `y' coordinate, leaving `x' alone.
		require
			in_bounds: (bounds.llx |..| bounds.urx).has (x) and then
						(bounds.lly |..| bounds.ury).has (y)
		do
			move_to (a_item, x, bounds.ury - y)
		end

	move_to (a_item: PDF_STREAM_ENTRY; a_x, a_y: INTEGER)
			-- Move point to `a_x' `a_y' according to `bounds'.
		require
			in_bounds: (bounds.llx |..| bounds.urx).has (a_x) and then
						(bounds.lly |..| bounds.ury).has (a_y)
		local
			l_moves: like new_x_y_moves
		do
			l_moves := new_x_y_moves (a_item, a_x, a_y)
			a_item.set_last_to_current
			a_item.Td_x_move := l_moves.move_x
			a_item.Td_y_move := l_moves.move_y
			a_item.apply_last_move
		ensure
			x_set: a_item.x = a_x
			y_set: a_item.y = a_y
		end

	new_x_y_moves (a_item: PDF_STREAM_ENTRY; a_new_x, a_new_y: INTEGER): TUPLE [move_x, move_y: INTEGER]
			-- Compute the values by which to move x and y
			--	given `x' and `y'.
		require
			in_bounds: (bounds.llx |..| bounds.urx).has (a_new_x) and then
						(bounds.lly |..| bounds.ury).has (a_new_y)
		do
			Result := [(a_new_x - a_item.x), (a_item.y  - a_new_y)]
		ensure
			in_bounds: (bounds.llx |..| bounds.urx).has (Result.move_x.abs) and then
						(bounds.lly |..| bounds.ury).has (Result.move_y.abs)
		end

feature -- {TEST_SET_BRIDGE} Implementation: Basic Operations: Constants

	Height_adjustment: INTEGER = 5
	Move_x_straight_down: INTEGER = 0
	Bottom_y_starting_point: INTEGER = 0
	Bottom_x_starting_point: INTEGER = 0
	Left_margin_x: INTEGER = 36
	Top_margin_y: INTEGER = 748
	Page_x_width_us_8_x_11: INTEGER = 612
	Page_y_height_us_8_x_11: INTEGER = 792
	Used_y_points_starting_value: INTEGER = 0

invariant
	valid_media_box: bounds.llx >= 0 and then bounds.lly >= 0 and then
						bounds.urx >= 0 and then bounds.ury >= 0 and then
						bounds.llx <= bounds.urx and then
						bounds.lly <= bounds.ury

;note

end
