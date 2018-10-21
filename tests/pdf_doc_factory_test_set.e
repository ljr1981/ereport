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
			l_list: ARRAYED_LIST [TUPLE [STRING, STRING, INTEGER]]
			l_font_name: STRING
			l_font_number,
			l_font_size: INTEGER
		do
				-- Supporting code
			create l_rand
			create l_list.make (200)
			across
				1 |..| l_rand.random_integer_in_range (100 |..| 200) as ic
			loop
--				l_font_number := l_rand.random_integer_in_range (1 |..| fonts_list.count)
--				l_font_name := fonts_list [l_font_number]
				l_font_size := l_rand.random_integer_in_range (6 |..| 20)
				l_list.force ([l_rand.random_word, "CourierNew", l_font_size])
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
						"Times New Roman"
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
					["01", "CourierNew", 10],
					["02", "CourierNew", 11],
					["03", "CourierNew", 12],
					["04", "CourierNew", 13],
					["05", "CourierNew", 14],
					["06", "CourierNew", 15],
					["07", "CourierNew", 16],
					["08", "CourierNew", 17],
					["09", "CourierNew", 18],
					["10", "CourierNew", 19],
					["11", "CourierNew", 20],
					["12", "CourierNew", 21],
					["13", "CourierNew", 22],
					["14", "CourierNew", 23],
					["15", "CourierNew", 24],
					["16", "CourierNew", 25],
					["17", "CourierNew", 26],
					["18", "CourierNew", 27],
					["19", "CourierNew", 28],
					["20", "CourierNew", 29],
					["21", "CourierNew", 30],
					["22", "CourierNew", 31],
					["23", "CourierNew", 32],
					["24", "CourierNew", 33],
					["25", "CourierNew", 34],
					["26", "CourierNew", 35],
					["27", "CourierNew", 36],
					["28", "CourierNew", 37],
					["29", "CourierNew", 38],
					["30", "CourierNew", 39],
					["31", "CourierNew", 40],
					["32", "CourierNew", 41],
					["33", "CourierNew", 42],
					["34", "CourierNew", 43],
					["35", "CourierNew", 44],
					["36", "CourierNew", 45],
					["37", "CourierNew", 46],
					["38", "CourierNew", 47],
					["39", "CourierNew", 48]
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
					["abc", "TimesNewRoman", 12],
					["123", "CourierNew", 10]
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
/Subtype /Type1
/BaseFont /TimesNewRoman
/Encoding /MacRomanEncoding
>>
endobj
5 0 obj
<<
/Type /Font
/Name /F2
/Subtype /Type1
/BaseFont /CourierNew
/Encoding /MacRomanEncoding
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
0000000376 00000 n
0000000485 00000 n
0000000598 00000 n
trailer
<<
/Size 7
/Root 1 0 R
>>
startxref
598
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
					["abc", "TimesNewRoman", 12],
					["123", "CourierNew", 10]
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

end


