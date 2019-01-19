note
	description: "Representation of a {PDF_STREAM_ENTRY}."
	EIS: "name=7.3.8", "protocol=URI", "src=https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/PDF32000_2008.pdf#page=27&zoom=150", "override=true"

class
	PDF_STREAM_ENTRY

inherit
	PDF_OBJECT [STRING]
		redefine
			default_create,
			pdf_out
		end

create
	make_with_font

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			make_with_media_box (create {PDF_MEDIA_BOX})
		end

	make_with_font (a_font: like font)
			--
		do
			font := a_font
			default_create
		end

	make_with_media_box (a_media_box: PDF_MEDIA_BOX)
			-- Initialize Current with `a_media_box' for `media_box_tuple'.
		do
			media_box := [a_media_box.bounds.llx, a_media_box.bounds.lly, a_media_box.bounds.urx, a_media_box.bounds.ury]
		end

	media_box: TUPLE [llx, lly, urx, ury: INTEGER]
			-- `media_box_refere'

feature -- Access

	font_name: STRING
			-- `font_name' as in /Name /F2 (key-value of Name=F2,
			--		which is font-obj reference)
		do
			Result := font.name_value
		end

	font_subtype: STRING
			-- `font_subtype' as in /Subtype /TrueType (key-value)
		do
			Result := font.subtype_value
		end

	font_basefont: STRING
			-- `font_basefont' as in /BaseFont /CourierNew (key-value of
			--		BaseFont=CourierNew, which is actual font name)
		do
			Result := font.basefont_value
		end

	font_encoding: STRING
			-- `font_encoding' as in /Encoding /StandardEncoding (key-value)
		do
			Result := font.encoding_value
		end

	font: PDF_FONT

	last_x: INTEGER assign set_last_x
			-- The `last_x' coordinate held by Current.

	x: INTEGER assign set_x
			-- The `x' coordinate (default = 0)

	last_y: INTEGER assign set_last_y
			-- The `last_y' coordinate held by Current.

	y: INTEGER assign set_y
			-- The `y' coordinate (default = 0)

feature -- Access: Stream Attributes

	Tf_font_ref_name: STRING
			-- `Tf_font_ref_name' (i.e. /F1 10 Tf)
		do
			Result := font.name_value
		end

	Tf_font_size: INTEGER assign set_Tf_font_size
			-- `Tf_font_size' (i.e. /F1 10 Tf)

	Td_x_move: INTEGER assign set_last_move_x
			-- `Td_x_move' (i.e. x, y Td in stream)

	Td_y_move: INTEGER assign set_last_move_y
			-- `Td_y_move' (i.e. x, y Td in stream)

	Tj_text: STRING assign set_Tj_text
			-- `Tj_text' (i.e. (my text) Tj)
		attribute
			create Result.make_empty
		end

feature -- Basic Operations

	give_same_coordinates (a_item: like Current)
			-- Give `a_item' same current `x' and `y'.
		do
			a_item.set_x (x)
			a_item.set_y (y)
		end

feature -- Setters

	apply_last_move
			-- Apply `last_x' and `last_y' to `x' and `y'.
		require
			last_x: last_x = x
			last_y: last_y = y
		do
			x := x + Td_x_move
			if Td_y_move < 0 then
				y := y + Td_y_move.abs
			else
				y := y - Td_y_move.abs
			end
		ensure
			moved_x: last_x = (x - Td_x_move)
			moved_y: (last_y = (y - Td_y_move.abs)) xor (last_y = (y + Td_y_move.abs))
		end

	set_last_to_current
			--
		do
			last_x := x
			last_y := y
		ensure
			set_y: last_x = x
			set_y: last_y = y
		end

	set_last_x (i: INTEGER)
			--
		do
			last_x := i
		ensure
			set: last_x = i
		end

	set_last_y (i: INTEGER)
			--
		do
			last_y := i
		ensure
			set: last_y = i
		end

	set_last_move_x (i: INTEGER)
			--
		do
			Td_x_move := i
		ensure
			set: Td_x_move = i
		end

	set_last_move_y (i: INTEGER)
			--
		do
			Td_y_move := i
		ensure
			set: Td_y_move = i
		end

	set_x (i: INTEGER)
			--
		do
			x := i
		ensure
			set: x = i
		end

	set_y (i: INTEGER)
			--
		do
			y := i
		ensure
			set: y = i
		end

	set_Tf_font_size (i: INTEGER)
			--
		do
			Tf_font_size := i
		ensure
			set: Tf_font_size = i
		end

	set_Tj_text (s: STRING)
			--
		do
			Tj_text := s
		ensure
			set: Tj_text.same_string (s)
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		local
			l_string: STRING
		do
			create Result.make_empty

				-- Tf
			Result.append_character ('/')
			Result.append_string_general (Tf_font_ref_name)
			Result.append_character (' ')
			Result.append_string_general (Tf_font_size.out)
			Result.append_character (' ')
			Result.append_string_general ("Tf")
			Result.append_character ('%N')
				-- Td
			Result.append_string_general (Td_x_move.out)
			Result.append_character (' ')
			Result.append_string_general (Td_y_move.out)
			Result.append_character (' ')
			Result.append_string_general ("Td")
			Result.append_character ('%N')
				-- Tj
			Result.append_character ('(')
			Result.append_string_general (Tj_text)
			Result.append_character (')')
			Result.append_character (' ')
			Result.append_string_general ("Tj")
			Result.append_character ('%N')
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := Solidus.out end
	closing_delimiter: STRING once ("OBJECT") Result := Space.out end

invariant
	valid_x: (media_box.llx |..| media_box.urx).has (x)
	valid_y: (media_box.lly |..| media_box.ury).has (y)
	valid_last_x: (media_box.llx |..| media_box.urx).has (last_x)
	valid_last_y: (media_box.lly |..| media_box.ury).has (last_y)
	valid_last_move_x: (media_box.llx |..| media_box.urx).has (Td_x_move.abs)
	valid_last_move_y: (media_box.lly |..| media_box.ury).has (Td_y_move.abs)

note
	example: "[
BT
/F1 20 Tf
120 120 Td
(Hello from Steve) Tj
ET
]"
	specifications: "[
		See the following specs:
		/Length		-- 7.3.8.2
		BT ... ET	-- 7.3.10 EXAMPLE 3, 9.2.2 Basics of Showing Text, 9.4.1 General
		Tf			-- 9.3.1 General (see table 104)
		Td			-- 9.4.2 Text-Positioning Operators (see table 108)
		Tj			-- 9.4.3 Text-Showing Operators (see table 109)
		]"
	glossary: "[
		BT - Begin Text
		ET - End Text
		Tf - Set font and font size (ex: /F1 20 Tf = Set font to ref@/F1 and size to 20 points)
		Td - Set text "delta" (ex: 120 120 Td = move to next line then offset to tx,ty of 120,120 within "rectangle" as starting position)
		Tj - Show a text string (ex: (some text) Tj = the text in parens is shown -- that is (..) = operand and Tj = operator)
		]"

end
