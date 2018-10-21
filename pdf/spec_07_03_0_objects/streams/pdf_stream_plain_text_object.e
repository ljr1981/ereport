note
	description: "Summary description for {PDF_STREAM_PLAIN_TEXT_OBJECT}."

class
	PDF_STREAM_PLAIN_TEXT_OBJECT

inherit
	PDF_INDIRECT_OBJECT
		redefine
			default_create,
			pdf_out
		end

create
	default_create,
	make_with_entries

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			Precursor
			create stream
			add_object (stream)
		end

	make_with_entries (a_list: ARRAY [TUPLE [Tf_font_name: STRING;
							Tf_font_size: INTEGER;
							Td_x, Td_y: INTEGER;
							Tj_text: STRING]])
		do
			default_create
			across
				a_list as ic
			loop
				entries.force (ic.item)
			end
		end

feature -- Access

	stream: PDF_STREAM_PLAIN_TEXT

	entries: ARRAYED_LIST [TUPLE [Tf_font_name: STRING;
							Tf_font_size: INTEGER;
							Td_x, Td_y: INTEGER;
							Tj_text: STRING]]
			--
		attribute
			create Result.make (10)
		end

--feature -- Settings

--	set_stream_text (a_text: STRING)
--		do
--			stream.set_text (a_text)
--		end

--feature -- Access

--	Tf_font_size: INTEGER

--feature {NONE} -- Implementation: Access

--	Td_x_offset,
--	Td_y_offset: INTEGER

--	Tf_font_ref: detachable PDF_FONT

--feature -- Settings

--	set_Td_offsets (x,y: INTEGER)
--			--
--		do
--			Td_x_offset := x
--			Td_y_offset := y
--		end

--	set_Tf_font_ref_and_size (a_ref: attached like Tf_font_ref; i: INTEGER)
--			--
--		do
--			set_Tf_font_ref (a_ref)
--			set_Tf_font_size (i)
--		end

--	set_Tf_font_ref (a_ref: attached like Tf_font_ref)
--			--
--		do
--			Tf_font_ref := a_ref
--		end

--	set_Tf_font_size (i: INTEGER)
--			--
--		do
--			Tf_font_size := i
--		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		local
			l_string: STRING
		do
			create l_string.make_empty

			l_string.append_string_general ("BT") -- Begin Text
			l_string.append_character ('%N')

			across
				entries as ic_entries
			loop
					-- Tf
				l_string.append_character ('/')
				l_string.append_string_general (ic_entries.item.Tf_font_name)
				l_string.append_character (' ')
				l_string.append_string_general (ic_entries.item.Tf_font_size.out)
				l_string.append_character (' ')
				l_string.append_string_general ("Tf")
				l_string.append_character ('%N')
					-- Td
				l_string.append_string_general (ic_entries.item.Td_x.out)
				l_string.append_character (' ')
				l_string.append_string_general (ic_entries.item.Td_y.out)
				l_string.append_character (' ')
				l_string.append_string_general ("Td")
				l_string.append_character ('%N')
					-- Tj
				l_string.append_character ('(')
				l_string.append_string_general (ic_entries.item.Tj_text)
				l_string.append_character (')')
				l_string.append_character (' ')
				l_string.append_string_general ("Tj")
				l_string.append_character ('%N')
			end

			l_string.append_string_general ("ET") -- End Text
			l_string.append_character ('%N')


			stream.set_text (l_string)
			Result := Precursor
		end

;note
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
