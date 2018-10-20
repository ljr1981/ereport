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

	build_single_page_pdf_test
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


