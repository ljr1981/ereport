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

	pdf_stream_table_tests
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_STREAM_TABLE
			l_entry: PDF_STREAM_ENTRY
			l_box: PDF_MEDIA_BOX
			l_font: PDF_FONT
		do
				-- prep
			create l_font.make_with_font_info (Unknown_font_number, TrueType_subtype, CourierNew_basefont, StandardEncoding_encoding)
			create l_entry.make_with_font (l_font)
			create l_box; l_box.set_portrait
			create l_item.make (Column_count, <<"1", "2", "3", "4">>, l_entry, l_box)

				-- test action
			l_item.generate (Last_font_number, Last_page_number, Last_stream_number)

				-- action result tests
			assert_integers_equal ("fonts_count", 1, l_item.fonts.count)
			assert_32 ("same_font_courier", attached l_item.fonts.item (CourierNew_basefont) as al_font and then l_font ~ al_font)
		end

feature {NONE} -- Test routines: Support

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


