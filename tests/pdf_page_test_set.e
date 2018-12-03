note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	PDF_PAGE_TEST_SET

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
		local
			l_file: PLAIN_TEXT_FILE
		do
--			create l_file.make_create_read_write (".\tests\assets\sample.pdf")
--			l_file.put_string (sample_pdf)
--			l_file.close

		end

feature -- Test routines: Basic Page

	page_test
			-- `page_test'
		do
				-- Test
			assert_strings_equal ("page_pdf_out", page_pdf_out, basic_page.pdf_out)
		end

feature {NONE} -- Test Support: Basic Page

	basic_page: PDF_PAGE
		local
			a_contents_ref: PDF_OBJECT_REFERENCE
			a_media_box: TUPLE [INTEGER_32, INTEGER_32, INTEGER_32, INTEGER_32]
			a_font_array: ARRAY [PDF_FONT]
			a_parent_object: PDF_INDIRECT_OBJECT

			l_content_object: PDF_INDIRECT_OBJECT
		once
				-- Prep: Content, Media, Font, Parent
			create l_content_object
			l_content_object.set_object_number (5)
			create a_contents_ref.make_with_object (l_content_object)
			a_media_box := [0, 0, 612, 792]
			a_font_array := <<>>
			create a_parent_object
			a_parent_object.set_object_number (3)

				-- Create
			create Result.make_with_fonts_and_parent (a_contents_ref, a_media_box, a_font_array, a_parent_object)
			Result.set_object_number (4)
		end

	page_pdf_out: STRING = "[
4 0 obj
<<
/Type /Page
/Parent 3 0 R
/Contents 5 0 R
/MediaBox [0 0 612 792]
/Resources <<
/ProcSet [/PDF /Text]
/Font <<
>>
>>
>>
endobj

]"

end


