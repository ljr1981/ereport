note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	PDF_FONT_TEST_SET

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

	font_test
			-- `font_test'
		local
			l_font: PDF_FONT
		do
			create l_font.make_with_font_info ("F1", {PDF_FONT}.Subtype_type_1, "Helvetica", {PDF_FONT}.Encoding_mac_roman)
			l_font.set_object_number (7)
				-- Test
			assert_strings_equal ("font_basic", font_basic, l_font.pdf_out)
		end

feature {NONE} -- Test Support: Basic

	font_basic: STRING = "[
7 0 obj
<<
/Type /Font
/Name /F1
/Subtype /Type1
/Basefont /Helvetica
/Encoding /MacRomanEncoding
>>
endobj

]"

end


