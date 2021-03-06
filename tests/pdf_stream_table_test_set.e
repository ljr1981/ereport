note
	description: "[
		Tests of {PDF_STREAM_TABLE}
	]"
	testing: "type/manual"

class
	PDF_STREAM_TABLE_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		redefine
			on_prepare
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

	FW_PROCESS_HELPER
		undefine
			default_create
		end

	PDF_CONSTANTS
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			do_nothing
		end

feature -- Test routines

	pdf_stream_table_font_tests
			-- New test routine
		note
			testing:  "execution/isolated"
		do
				-- action result tests
			check font_found: stream_table.fonts.count = 1 and then attached stream_table.fonts.item (CourierNew_basefont) as al_font then
				assert_strings_equal ("same_font_courier_new", CourierNew_basefont, al_font.basefont_value)
				assert_strings_equal ("font_pdf_out_1", font_pdf_out_1, al_font.pdf_out)
			end
		end

feature {NONE} -- Test routines: Support

	font_pdf_out_1: STRING = "[
1 0 obj
<<
/Type /Font
/Name /Fx
/Subtype /TrueType
/Basefont /CourierNew
/Encoding /StandardEncoding
>>
endobj

]"

feature -- Test routines

	pdf_stream_table_positions_tests
			-- New test routine
		note
			testing:  "execution/isolated"
		do
			assert_integers_equal ("positions_count", 4, stream_table.positions_list.count)
			assert_32 ("posn_1_x_y", stream_table.positions_list.item (1, 1) ~ [0, 148, 20, 0, 0])		-- x, x_right, y
			assert_32 ("posn_2_x_y", stream_table.positions_list.item (1, 2) ~ [153, 301, 20, 0, 0])
			assert_32 ("posn_3_x_y", stream_table.positions_list.item (1, 3) ~ [306, 454, 20, 0, 0])
			assert_32 ("posn_4_x_y", stream_table.positions_list.item (1, 4) ~ [459, 607, 20, 0, 0])

			assert_integers_equal ("positions_count", 8, stream_table_2.positions_list.count)
			assert_32 ("posn_1_x_y", stream_table_2.positions_list.item (1, 1) ~ [0, 148, 20, 0, 0])		-- x, x_right, y
			assert_32 ("posn_2_x_y", stream_table_2.positions_list.item (1, 2) ~ [153, 301, 20, 0, 0])
			assert_32 ("posn_3_x_y", stream_table_2.positions_list.item (1, 3) ~ [306, 454, 20, 0, 0])
			assert_32 ("posn_4_x_y", stream_table_2.positions_list.item (1, 4) ~ [459, 607, 20, 0, 0])

			assert_32 ("posn_5_x_y", stream_table_2.positions_list.item (2, 1) ~ [0, 148, 40, 0, 0])		-- x, x_right, y
			assert_32 ("posn_6_x_y", stream_table_2.positions_list.item (2, 2) ~ [153, 301, 40, 0, 0])
			assert_32 ("posn_7_x_y", stream_table_2.positions_list.item (2, 3) ~ [306, 454, 40, 0, 0])
			assert_32 ("posn_8_x_y", stream_table_2.positions_list.item (2, 4) ~ [459, 607, 40, 0, 0])

			assert_32 ("posn_1_x_y_scaled", stream_table_2.positions_list_with_margins (36, 36, 36, 36).item (1, 1) ~ [x_36, x_right_166, y_56, page_1, row_1])		-- 0 + 36, (88% of 148), 20 + 36
			assert_32 ("posn_2_x_y_scaled", stream_table_2.positions_list_with_margins (36, 36, 36, 36).item (1, 2) ~ [171, 301, 56, 1, 1])
			assert_32 ("posn_3_x_y_scaled", stream_table_2.positions_list_with_margins (36, 36, 36, 36).item (1, 3) ~ [306, 436, 56, 1, 1])
			assert_32 ("posn_4_x_y_scaled", stream_table_2.positions_list_with_margins (36, 36, 36, 36).item (1, 4) ~ [441, 571, 56, 1, 1])

			assert_32 ("posn_5_x_y_scaled", stream_table_2.positions_list_with_margins (36, 36, 36, 36).item (2, 1) ~ [36, 166, 76, 1, 2])		-- x, x_right, y
			assert_32 ("posn_6_x_y_scaled", stream_table_2.positions_list_with_margins (36, 36, 36, 36).item (2, 2) ~ [171, 301, 76, 1, 2])
			assert_32 ("posn_7_x_y_scaled", stream_table_2.positions_list_with_margins (36, 36, 36, 36).item (2, 3) ~ [306, 436, 76, 1, 2])
			assert_32 ("posn_8_x_y_scaled", stream_table_2.positions_list_with_margins (36, 36, 36, 36).item (2, 4) ~ [441, 571, 76, 1, 2])

		end

feature {NONE} -- Testing: Support

	x_36: INTEGER = 36
	x_right_166: INTEGER = 166
	y_56: INTEGER = 56
	page_1: INTEGER = 1
	row_1: INTEGER = 1


	pdf_stream_table_multipage_positions_tests
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item_count: INTEGER
		do
				-- Prep work
			l_item_count := Page_count_4 * Lines_count_30 * Columns_count_4

				-- Application
			stream_table_3.generate_pages_and_streams (Left_margin_36, Top_margin_36, Right_margin_36, Bottom_margin_36)

				-- Tests: `stream_table_3.stream_entries' (entries)
			assert_integers_equal ("stream_table_3_stream_entries_count", l_item_count, stream_table_3.stream_entries.count)

				-- Tests: `stream_table_3.fonts'
			assert_integers_equal ("stream_table_3_fonts_count", 1, stream_table_3.fonts.count)

				-- CONCLUSION: We have Results = 480, Entries = 480, and Fonts = 1
				-- SO: We can now ...
				--		1. Isolate the 480 Entries by page, which is in the `l_result' (Results).
				--			Once we have isolated
		end

feature {NONE} -- Test routines: Support

	pages_pdf_out_1: STRING = "[

]"

feature {NONE} -- Test routines: Support

	stream_table: PDF_STREAM_TABLE
		local
			l_entry: PDF_STREAM_ENTRY
			l_box: PDF_MEDIA_BOX
			l_font: PDF_FONT
		once
				-- prep
			create l_font.make_with_font_info (Unknown_font_number, TrueType_subtype, CourierNew_basefont, StandardEncoding_encoding)
			create l_entry.make_with_font (l_font)
			l_entry.set_tf_font_size (20)
			create l_box; l_box.set_portrait
			create Result.make (Column_count, <<"1", "2", "3", "4">>, l_entry, l_box)

				-- test action
			Result.generate (Last_font_number, Last_page_number, Last_stream_number)
		end

	stream_table_2: PDF_STREAM_TABLE
		local
			l_entry: PDF_STREAM_ENTRY
			l_box: PDF_MEDIA_BOX
			l_font: PDF_FONT
		once
				-- prep
			create l_font.make_with_font_info (Unknown_font_number, TrueType_subtype, CourierNew_basefont, StandardEncoding_encoding)
			create l_entry.make_with_font (l_font)
			l_entry.set_tf_font_size (20)
			create l_box; l_box.set_portrait
			create Result.make (Column_count, <<"1", "2", "3", "4", "5", "6", "7", "8">>, l_entry, l_box)

				-- test action
			Result.generate (Last_font_number, Last_page_number, Last_stream_number)
		end

	stream_table_3: PDF_STREAM_TABLE
		local
			l_entry: PDF_STREAM_ENTRY
			l_box: PDF_MEDIA_BOX
			l_font: PDF_FONT
			l_rand: RANDOMIZER
			l_values: ARRAY [STRING]
		once
				-- prep
			create l_font.make_with_font_info (Unknown_font_number, TrueType_subtype, CourierNew_basefont, StandardEncoding_encoding)
			create l_entry.make_with_font (l_font)
			l_entry.set_tf_font_size (20)
			create l_box; l_box.set_portrait
			create l_rand
			create Result.make (Column_count, l_rand.random_array_strings (Page_count_4 * Lines_count_30 * Columns_count_4), l_entry, l_box)

				-- test action
			Result.generate (Last_font_number, Last_page_number, Last_stream_number)
		end

feature {NONE} -- Test routines: Support

	Left_margin_36: INTEGER = 36
	Top_margin_36: INTEGER = 36
	Right_margin_36: INTEGER = 36
	Bottom_margin_36: INTEGER = 36

	Page_count_4: INTEGER = 4
	Lines_count_30: INTEGER = 30
	Columns_count_4: INTEGER = 4

	Row_count: INTEGER = 1
	Column_count: INTEGER = 4

	Unknown_font_number: STRING = "Fx"
	TrueType_subtype: STRING = "TrueType"
	CourierNew_basefont: STRING = "CourierNew"
	StandardEncoding_encoding: STRING = "StandardEncoding"
	Last_font_number: INTEGER = 0
	Last_page_number: INTEGER = 0
	Last_stream_number: INTEGER = 0

end


