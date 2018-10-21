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
		end

feature -- Test routines

	build_single_page_pdf_file_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_DOC_FACTORY
				-- Supporting types
			l_font: PDF_FONT
			l_fonts: ARRAYED_LIST [PDF_FONT]

			l_page_tree: PDF_PAGE_TREE [PDF_PAGE_US]

			l_page: PDF_PAGE_US
			l_pages: ARRAYED_LIST [PDF_PAGE_US]
			l_page_refs: ARRAYED_LIST [PDF_OBJECT_REFERENCE]

			l_stream: PDF_STREAM_PLAIN_TEXT_OBJECT
			l_streams: ARRAYED_LIST [PDF_STREAM_PLAIN_TEXT_OBJECT]
			l_catalog: PDF_CATALOG

			l_doc: PDF_DOCUMENT
			
			l_but_got: STRING
		do
				-- Builder
			create l_item
			l_item.build (<<
					["abc", "TimesNewRoman", 12],
					["123", "CourierNew", 10]
					>>)

				-- List of PDF_FONT items
			create l_fonts.make (l_item.fonts.count)
			across
				l_item.fonts as ic_fonts
			loop
				create l_font.make_with_font_info (ic_fonts.item.name, ic_fonts.item.subtype, ic_fonts.item.basefont, ic_fonts.item.encoding)
			end

				-- List of PDF_STREAM_PLAIN_TEXT_OBJECT items
			create l_streams.make (10)

				-- List of PDF_PAGE items
			check attached l_item.page_tree_ind_obj as al_page_tree then
				create l_pages.make (al_page_tree.kids.count)
				across
					l_item.catalog_ind_obj.pages.kids as ic_pages
				loop
					check has_stream: attached ic_pages.item.stream as al_stream then
						create l_stream.make_with_entries (al_stream.entries.to_array)
						l_streams.force (l_stream)
					end
					create l_page.make_with_contents (l_stream.ref, l_fonts.to_array)
					l_pages.force (l_page)
				end
			end

				-- PDF_PAGE_TREE
			create l_page_refs.make (l_pages.count)
			across l_pages as ic loop
				l_page_refs.force (ic.item.ref)
			end
			create l_page_tree.make_with_kids (l_page_refs.to_array)

				-- Catalog
			create l_catalog.make_with_pages (l_page_tree.ref)

				-- Document
			create l_doc
			l_doc.body.add_object (l_catalog)
			l_doc.body.add_object (l_page_tree)
			across l_pages as ic loop
				l_doc.body.add_object (ic.item)
			end
			across l_fonts as ic loop
				l_doc.body.add_object (ic.item)
			end
			across l_streams as ic loop
				l_doc.body.add_object (ic.item)
			end

			l_but_got := l_doc.pdf_out.twin
			l_but_got.replace_substring_all ("%R", "")
			assert_strings_equal ("test_pdf_text", test_pdf_text, l_but_got)
		end

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
/Contents 4 0 R
/Resources <<
/ProcSet [/PDF /Text]
/Font <<
>>
>>
/Parent 2 0 R
>>
endobj
4 0 obj
<<
/Length 63
>>
stream
BT
/F1 12 Tf
36 748 Td
(abc) Tj
/F2 10 Tf
0 -12 Td
(123) Tj
ET

endstream
endobj
xref
0 4
0000000000 65535 f
0000000049 00000 n
0000000106 00000 n
0000000220 00000 n
0000000333 00000 n
trailer
<<
/Size 5
/Root 1 0 R
>>
startxref
333
%%EOF
]"

-------------------------------------------------


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
			check has_f1: attached l_item.fonts ["F1"] as al_font_item then
				assert_strings_equal ("F1", "F1", al_font_item.name)
				assert_strings_equal ("TimesNewRoman", "TimesNewRoman", al_font_item.basefont)
			end
			check has_f2: attached l_item.fonts ["F2"] as al_font_item then
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
					assert_integers_equal ("Td_x", 0, al_entry.Td_x)
					assert_integers_equal ("Td_y", -15, al_entry.Td_y)
					assert_strings_equal ("text", "abc", al_entry.Tj_text)
				end
				check has_entry_1: attached al_stream.entries [2] as al_entry then
					assert_strings_equal ("name_F2", "F2", al_entry.Tf_font_name)
					assert_integers_equal ("size_10", 10, al_entry.Tf_font_size)
					assert_integers_equal ("Td_x", 0, al_entry.Td_x)
					assert_integers_equal ("Td_y", -12, al_entry.Td_y)
					assert_strings_equal ("text", "123", al_entry.Tj_text)
				end
			end
		end

end


