note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"

class
	PDF_OUTLINES_TEST_SET

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

feature -- Test routines

	outlines_dictionary_test
			-- `outlines_dictionary_test'
		local
			l_outlines: PDF_OUTLINES
		do
			create l_outlines
			l_outlines.set_object_number (2)

				-- Tests
			assert_strings_equal ("outlines_dictionary_pdf_out", outlines_dictionary_pdf_out, l_outlines.pdf_out)
		end

feature {NONE} -- Test Support

	outlines_dictionary_pdf_out: STRING = "[
2 0 obj
<<
/Type /Outlines
/Count 0
>>
endobj

]"

end


