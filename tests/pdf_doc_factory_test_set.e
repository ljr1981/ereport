note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_DOC_FACTORY_TEST_SET

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

feature {NONE} -- Initialization

	on_prepare
			-- <Precursor>
		do
			Precursor
			fonts_list.do_nothing
		end

feature -- Test routines

	build_table_6_pdf_test
			--
		note
			test: "execution/isolated"
		local
			l_factory: PDF_DOC_FACTORY
			l_table_1_1,
			l_table_2_2: PDF_STREAM_TABLE
			l_entry: PDF_STREAM_ENTRY
				-- Support
			l_file: PLAIN_TEXT_FILE
			l_fonts: HASH_TABLE [PDF_FONT, STRING]
			l_font_courier: PDF_FONT
		do
			create l_fonts.make (1)
			create l_font_courier.make_with_font_info ("F1", "TrueType", "CourierNew", "StandardEncoding")
			l_fonts.force (l_font_courier, l_font_courier.basefont_value)

			create l_entry.make_with_font (l_font_courier)
			l_entry.set_Tj_text ("abc")
			l_entry.set_tf_font_size (20)

			create l_table_1_1.make (1, 1)
			l_table_1_1.set_default_entry (l_entry)

			create l_entry.make_with_font (l_font_courier)
			l_entry.set_Tj_text ("123")
			l_entry.set_tf_font_size (10)
			create l_table_2_2.make (2, 2)
			l_table_2_2.set_default_entry (l_entry)

			create l_factory
			l_factory.build_and_generate (<<
										l_table_1_1,
										l_table_2_2
									>>, l_fonts)

			create l_file.make_create_read_write (".\tests\assets\generated_sample_6.pdf")
			l_file.put_string (l_factory.generated_pdf_attached.pdf_out)
			l_file.close
		end

feature -- Test routines

	build_multi_page_random_5_pdf_file_test
			-- Build a smaple multi-page report using
			-- random number of randomly generated words.
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_DOC_FACTORY

				-- Support
			l_file: PLAIN_TEXT_FILE
			l_rand: RANDOMIZER
			l_list: ARRAYED_LIST [TUPLE [STRING, STRING, INTEGER, INTEGER]]
			l_font_name: STRING
			l_font_number,
			l_font_size: INTEGER
		do
				-- Supporting code
			create l_rand
			create l_list.make (200)
			across
				1 |..| 100 as ic
			loop
				l_font_number := l_rand.random_integer_in_range (1 |..| fonts_list.count)
				l_font_name := fonts_list [l_font_number]
				l_font_size := l_rand.random_integer_in_range (6 |..| 20)
				if (ic.cursor_index \\ 2) = 0 then
					l_list.force ([l_rand.random_word, "CourierNew", l_font_size, 36])
				else
					l_list.force ([l_rand.random_word, "TimesNewRoman", l_font_size, 36])
				end
			end

				-- Building code
			create l_item
			l_item.build (l_list.to_array)
			l_item.generate_from_build

			create l_file.make_create_read_write (".\tests\assets\generated_sample_5.pdf")
			l_file.put_string (l_item.generated_pdf_attached.pdf_out)
			l_file.close
		end

feature {NONE} -- Implementation: Test Support

	fonts_list: ARRAY [STRING]
		once ("OBJECT")
			Result := <<
						"CourierNew",
						"TimesNewRoman"
						>>
		end

feature -- Test routines

	build_multi_page_4_pdf_file_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_DOC_FACTORY
			l_but_got: STRING
			l_file: PLAIN_TEXT_FILE
		do
			create l_item
			l_item.build (<<
					["01", "CourierNew", 10, 36],
					["02", "CourierNew", 11, 36],
					["03", "CourierNew", 12, 36],
					["04", "CourierNew", 13, 36],
					["05", "CourierNew", 14, 36],
					["06", "CourierNew", 15, 36],
					["07", "CourierNew", 16, 36],
					["08", "CourierNew", 17, 36],
					["09", "CourierNew", 18, 36],
					["10", "CourierNew", 19, 36],
					["11", "CourierNew", 20, 36],
					["12", "CourierNew", 21, 36],
					["13", "CourierNew", 22, 36],
					["14", "CourierNew", 23, 36],
					["15", "CourierNew", 24, 36],
					["16", "CourierNew", 25, 36],
					["17", "CourierNew", 26, 36],
					["18", "CourierNew", 27, 36],
					["19", "CourierNew", 28, 36],
					["20", "CourierNew", 29, 36],
					["21", "CourierNew", 30, 36],
					["22", "CourierNew", 31, 36],
					["23", "CourierNew", 32, 36],
					["24", "CourierNew", 33, 36],
					["25", "CourierNew", 34, 36],
					["26", "CourierNew", 35, 36],
					["27", "CourierNew", 36, 36],
					["28", "CourierNew", 37, 36],
					["29", "CourierNew", 38, 36],
					["30", "CourierNew", 39, 36],
					["31", "CourierNew", 40, 36],
					["32", "CourierNew", 41, 36],
					["33", "CourierNew", 42, 36],
					["34", "CourierNew", 43, 36],
					["35", "CourierNew", 44, 36],
					["36", "CourierNew", 45, 36],
					["37", "CourierNew", 46, 36],
					["38", "CourierNew", 47, 36],
					["39", "CourierNew", 48, 36]
					>>)
			l_item.generate_from_build

			create l_file.make_create_read_write (".\tests\assets\generated_sample_4.pdf")
			l_file.put_string (l_item.generated_pdf_attached.pdf_out)
			l_file.close
		end

	build_single_page_3_pdf_file_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_DOC_FACTORY
			l_but_got: STRING
			l_file: PLAIN_TEXT_FILE
		do
			create l_item
			l_item.build (<<
					["abc", "TimesNewRoman", 12, 36],
					["123", "CourierNew", 10, 36]
					>>)
			l_item.generate_from_build
			l_but_got := l_item.generated_pdf_attached.pdf_out.twin
			l_but_got.replace_substring_all ("%R", "")
			assert_strings_equal ("test_pdf_text", test_pdf_text, l_but_got)

			create l_file.make_create_read_write (".\tests\assets\generated_sample_3.pdf")
			l_file.put_string (l_item.generated_pdf_attached.pdf_out)
			l_file.close
		end

feature {NONE} -- Implementation: Test Support
-------------------------------------------------

	test_pdf_text: STRING = "[
%PDF-1.4
1 0 obj
<<
/Type /Catalog
/Pages 2 0 R
>>
endobj
2 0 obj
<<
/Count 1
/Type /Pages
/Kids [3 0 R]
>>
endobj
3 0 obj
<<
/Type /Page
/Contents 6 0 R
/MediaBox [0 0 612 792]
/Resources <<
/ProcSet [/PDF /Text]
/Font <<
/F1 4 0 R
/F2 5 0 R
>>
>>
/Parent 2 0 R
>>
endobj
4 0 obj
<<
/Type /Font
/Name /F1
/Subtype /TrueType
/Basefont /TimesNewRoman
/Encoding /StandardEncoding
>>
endobj
5 0 obj
<<
/Type /Font
/Name /F2
/Subtype /TrueType
/Basefont /CourierNew
/Encoding /StandardEncoding
>>
endobj
6 0 obj
<<
/Length 63
>>
stream
BT
/F1 12 Tf
36 748 Td
(abc) Tj
/F2 10 Tf
0 -17 Td
(123) Tj
ET

endstream
endobj
xref
0 6
0000000000 65535 f
0000000049 00000 n
0000000106 00000 n
0000000264 00000 n
0000000379 00000 n
0000000491 00000 n
0000000604 00000 n
trailer
<<
/Size 7
/Root 1 0 R
>>
startxref
604
%%EOF
]"

-------------------------------------------------

feature -- Test routines

	build_single_page_tuple_item_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_DOC_FACTORY
		do
				-- Builder
			create l_item
			l_item.build (<<
					["abc", "TimesNewRoman", 12, 36],
					["123", "CourierNew", 10, 36]
					>>)

				-- Tests: Relationships & References
			--assert_32 ("same_ref", l_item.page_tree_ind_obj.kids ~ l_item.pages)

				-- Tests: Catalog
			assert_integers_equal ("catalog_ind_obj_pages_page_count", 1, l_item.catalog_ind_obj.pages.page_count)

				-- Tests: Page Tree
			assert_integers_equal ("page_tree_page_count", 1, l_item.page_tree_ind_obj.page_count)
			assert_integers_equal ("page_tree_kids_count", 1, l_item.page_tree_ind_obj.kids.count)

				-- Tests: Fonts
			assert_integers_equal ("font_count", 2, l_item.fonts.count)
			check has_f1: attached l_item.fonts ["TimesNewRoman"] as al_font_item then
				assert_strings_equal ("F1", "F1", al_font_item.name)
				assert_strings_equal ("TimesNewRoman", "TimesNewRoman", al_font_item.basefont)
			end
			check has_f2: attached l_item.fonts ["CourierNew"] as al_font_item then
				assert_strings_equal ("F2", "F2", al_font_item.name)
				assert_strings_equal ("CourierNew", "CourierNew", al_font_item.basefont)
			end

				-- Tests: Page(s)
			assert_integers_equal ("pages_count", 1, l_item.page_tree_ind_obj.page_count)

				-- Tests: Stream(s)
			check has_kid_1: attached l_item.page_tree_ind_obj.kids [1] as al_page then
				check has_stream: attached al_page.stream as al_stream end
			end

				-- Tests: Stream-entries
			check has_stream_for_entries: attached l_item.page_tree_ind_obj.kids [1] as al_page and then
				attached al_page.stream as al_stream
			then
				assert_integers_equal ("entries_count", 2, al_stream.entries.count)
				check has_entry_1: attached al_stream.entries [1] as al_entry then
					assert_strings_equal ("name_F1", "F1", al_entry.Tf_font_name)
					assert_integers_equal ("size_12", 12, al_entry.Tf_font_size)
					assert_integers_equal ("Td_x", 36, al_entry.Td_x)
					assert_integers_equal ("Td_y", 748, al_entry.Td_y)
					assert_strings_equal ("text", "abc", al_entry.Tj_text)
				end
				check has_entry_1: attached al_stream.entries [2] as al_entry then
					assert_strings_equal ("name_F2", "F2", al_entry.Tf_font_name)
					assert_integers_equal ("size_10", 10, al_entry.Tf_font_size)
					assert_integers_equal ("Td_x", 0, al_entry.Td_x)
					assert_integers_equal ("Td_y", -17, al_entry.Td_y)
					assert_strings_equal ("text", "123", al_entry.Tj_text)
				end
			end
		end

	x_y_moving_tests
			--
		local
			l_item: PDF_DOC_FACTORY
			l_entry: PDF_STREAM_ENTRY
		do
			create l_item
			create l_entry.make_with_font (create {PDF_FONT}.make ("Fx"))
			check attached {TUPLE [INTEGER, INTEGER]} l_item.media_box_obj.new_x_y_moves (l_entry, 0, 792) as al_result then
				check attached {INTEGER} al_result [1] as al_item then
					assert_integers_equal ("move_x", 0, al_item)
				end
				check attached {INTEGER} al_result [2] as al_item then
					assert_integers_equal ("move_y", -792, al_item)
				end
			end

				-- Move 1
			l_item.media_box_obj.move_to (l_entry, 0, 792)
			assert_integers_equal ("last_x_1", 0, l_entry.last_x)
			assert_integers_equal ("last_y_1", 0, l_entry.last_y)
			assert_integers_equal ("last_move_x_1", 0, l_entry.Td_x_move)
			assert_integers_equal ("last_move_y_1", -792, l_entry.Td_y_move)
			assert_integers_equal ("current_x_1", 0, l_entry.x)
			assert_integers_equal ("current_y_1", 792, l_entry.y)
				-- Move 2
			l_item.media_box_obj.move_to (l_entry, 300, 300)
			assert_integers_equal ("last_x_2", 0, l_entry.last_x)
			assert_integers_equal ("last_y_2", 792, l_entry.last_y)
			assert_integers_equal ("last_move_x_2", 300, l_entry.Td_x_move)
			assert_integers_equal ("last_move_y_2", 492, l_entry.Td_y_move)
			assert_integers_equal ("current_x_2", 300, l_entry.x)
			assert_integers_equal ("current_y_2", 300, l_entry.y)
				-- Move 3 natural
			l_item.media_box_obj.move_to_natural (l_entry, 300, 300)
			assert_integers_equal ("last_x_3", 300, l_entry.last_x)
			assert_integers_equal ("last_y_3", 300, l_entry.last_y)
			assert_integers_equal ("last_move_x_3", 0, l_entry.Td_x_move)
			assert_integers_equal ("last_move_y_3", -192, l_entry.Td_y_move)
			assert_integers_equal ("current_x_3", 300, l_entry.x)
			assert_integers_equal ("current_y_3", 492, l_entry.y)
				-- Move 4 natural
			l_item.media_box_obj.move_to_natural (l_entry, 400, 400)
			assert_integers_equal ("last_x_4", 300, l_entry.last_x)
			assert_integers_equal ("last_y_4", 492, l_entry.last_y)
			assert_integers_equal ("last_move_x_4", 100, l_entry.Td_x_move)
			assert_integers_equal ("last_move_y_4", 100, l_entry.Td_y_move)
			assert_integers_equal ("current_x_4", 400, l_entry.x)
			assert_integers_equal ("current_y_4", 392, l_entry.y)
				-- Move 5 natural
			l_item.media_box_obj.move_to_natural (l_entry, 0, 0)
			assert_integers_equal ("last_x_5", 400, l_entry.last_x)
			assert_integers_equal ("last_y_5", 392, l_entry.last_y)
			assert_integers_equal ("last_move_x_5", -400, l_entry.Td_x_move)
			assert_integers_equal ("last_move_y_5", -400, l_entry.Td_y_move)
			assert_integers_equal ("current_x_5", 0, l_entry.x)
			assert_integers_equal ("current_y_5", 792, l_entry.y)
		end

end


