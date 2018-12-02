note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	PDF_CATALOG_TEST_SET

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

feature -- Tests: Basic

	document_catalog_test
			-- Test of {PDF_CATALOG} - basic
		note
			description: "[
				The most basic PDF Catalog object possible.
				]"
		local
			l_catalog: PDF_CATALOG
			l_pages_ref: PDF_OBJECT_REFERENCE
			l_ind_object: PDF_INDIRECT_OBJECT
		do
			create l_ind_object
			create l_pages_ref.make_with_object (l_ind_object)
			create l_catalog.make_with_pages (l_pages_ref)
			l_catalog.set_object_number (1)
			assert_strings_equal ("catalog_pdf_out", catalog_pdf_out, l_catalog.pdf_out)
		end

feature {NONE} -- Test Support

	catalog_pdf_out: STRING = "[
1 0 obj
<<
/Type /Catalog
/Pages 0 0 R
>>
endobj

]"

feature -- Tests: H.2 Minimal Catalog PDF out

	h_2_minimal_document_catalog_test
			-- Test of {PDF_CATALOG} - based on H.2 Minimal in PDF Specification
		note
			description: "[
				See H.2 EXAMPLE
				]"
		local
			l_catalog: PDF_CATALOG
			l_pages_ref,
			l_outlines_ref: PDF_OBJECT_REFERENCE
			l_ind_object: PDF_INDIRECT_OBJECT
		do
				-- /Pages
			create l_ind_object
			l_ind_object.set_object_number (3)
			create l_pages_ref.make_with_object (l_ind_object)

				-- /Outlines
			create l_ind_object
			l_ind_object.set_object_number (2)
			create l_outlines_ref.make_with_object (l_ind_object)

				-- /Type Catalog
			create l_catalog.make (l_pages_ref, l_outlines_ref)
			l_catalog.set_object_number (1)

				-- Testing
			assert_strings_equal ("h2_minimal_catalog_pdf_out", h2_minimal_catalog_pdf_out, l_catalog.pdf_out)
		end

feature {NONE} -- Test Support

	h2_minimal_catalog_pdf_out: STRING = "[
1 0 obj
<<
/Type /Catalog
/Outlines 2 0 R
/Pages 3 0 R
>>
endobj

]"

end


