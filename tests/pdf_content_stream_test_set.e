note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"

class
	PDF_CONTENT_STREAM_TEST_SET

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
			do_nothing
		end

feature -- Tests: Basic

	content_stream_test
			-- `content_stream_test'
		local
			l_stream: PDF_CONTENT_STREAM
		do
			create l_stream
			l_stream.set_object_number (5)
			l_stream.set_length (35)

				-- Test
			assert_strings_equal ("content_stream_basic", content_stream_basic, l_stream.pdf_out)
		end

feature {NONE} -- Test Support: Basic

	content_stream_basic: STRING = "[
5 0 obj
<<
/Length 35
>> stream
endstream
endobj

]"

end


