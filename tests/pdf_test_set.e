note
	description: "Summary description for {PDF_TEST_SET}."
	testing: "type/manual"

class
	PDF_TEST_SET

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
			create l_file.make_create_read_write (".\tests\assets\sample.pdf")
			l_file.put_string (sample_pdf)
			l_file.close

		end

feature -- Tests

	test_sample_pdf_boolean
			-- test
		local
			l_item: PDF_BOOLEAN
		do
			create l_item
			l_item.set_true
			assert_strings_equal ("pdf_boolean_true", "true", l_item.pdf_out)
			assert_integers_equal ("pdf_boolean_length", 4, l_item.length)
			assert_strings_equal ("pdf_boolean_hex_length", "00000004", l_item.length_hex)
		end

	test_sample_pdf_decimal
			-- test
		local
			l_item: PDF_DECIMAL
		do
			create l_item.make_with_integer (999_888_777)
			assert_strings_equal ("pdf_decimal_true", "999888777", l_item.pdf_out)
			assert_integers_equal ("pdf_decimal_length", 9, l_item.length)
			assert_strings_equal ("pdf_decimal_hex_length", "00000009", l_item.length_hex)
		end

	test_sample_pdf_integer
			-- test
		local
			l_item: PDF_INTEGER
		do
			create l_item.make_with_integer (999_888_777)
			assert_strings_equal ("pdf_integer_true", "999888777", l_item.pdf_out)
			assert_integers_equal ("pdf_integer_length", 9, l_item.length)
			assert_strings_equal ("pdf_integer_hex_length", "00000009", l_item.length_hex)
		end

	test_sample_pdf_name
			-- test
		local
			l_item: PDF_NAME
		do
			create l_item.make ("Name1")
			assert_strings_equal ("name1", "/Name1", l_item.pdf_out)

			create l_item.make ("ASomewhat LongerName")
			assert_strings_equal ("pdf_name_text", "/ASomewhat#20LongerName", l_item.pdf_out)
			assert_integers_equal ("pdf_integer_length", 23, l_item.length)
			assert_strings_equal ("pdf_integer_hex_length", "00000017", l_item.length_hex)

			create l_item.make ("A;Name_With-Various***Characters?")
			assert_strings_equal ("name_with_various", "/A;Name_With-Various***Characters?", l_item.pdf_out)

			create l_item.make ("1.2")
			assert_strings_equal ("one_point_two", "/1.2", l_item.pdf_out)

			create l_item.make ("$$")
			assert_strings_equal ("dollar_dollar", "/$$", l_item.pdf_out)

			create l_item.make ("@Pattern")
			assert_strings_equal ("at_pattern", "/@Pattern", l_item.pdf_out)

			create l_item.make ("Paired()Parenthesis")
			assert_strings_equal ("paired_parenthesis", "/Paired#28#29Parenthesis", l_item.pdf_out)

			create l_item.make ("The_Key_of_F#_Minor")
			assert_strings_equal ("f_sharp_minor", "/The_Key_of_F#23_Minor", l_item.pdf_out)
		end

	test_sample_pdf_string
			-- test
		local
			l_item: PDF_STRING
		do
			create l_item.make_as_literal ("Some %Ttext (like this)%N for a string %B%R%F\")
			assert_strings_equal ("pdf_string_text", "(Some \ttext \(like this\)\n for a string \b\r\f\)", l_item.pdf_out)
			assert_integers_equal ("pdf_string_length", 50, l_item.length)
			assert_strings_equal ("pdf_string_hex_length", "00000032", l_item.length_hex)

			create l_item.make_as_hex (<<>>)
		end

feature {NONE} -- Test Support: In-system References

	pdf_boolean: detachable PDF_BOOLEAN
	pdf_integer: detachable PDF_INTEGER
	pdf_decimal: detachable PDF_DECIMAL
	pdf_string: detachable PDF_STRING
	pdf_array: detachable PDF_ARRAY
	pdf_name: detachable PDF_NAME

feature {NONE} -- Test Support: PDF

	sample_pdf: STRING = "[
%PDF-1.4
1 0 obj
<</Type /Catalog
/Pages 2 0 R
>>
endobj
2 0 obj
<</Type /Pages
/Kids [3 0 R]
/Count 1
>>
endobj
3 0 obj
<</Type /Page
/Parent 2 0 R
/MediaBox [0 0 500 500]
/Contents 5 0 R
/Resources <</ProcSet [/PDF /Text]
/Font <</F1 4 0 R>>
>>
>>
endobj
4 0 obj
<</Type /Font
/Subtype /Type1
/Name /F1
/BaseFont /Helvetica
/Encoding /MacRomanEncoding
>>
endobj

5 0 obj
<</Length 53
>>
stream
BT
/F1 20 Tf
120 120 Td
(Hello from Larry Rix) Tj
ET
endstream
endobj
xref
0 6
0000000000 65535 f
0000000009 00000 n
0000000063 00000 n
0000000124 00000 n
0000000277 00000 n
0000000392 00000 n
trailer
<</Size 6
/Root 1 0 R
>>
startxref
502
%%EOF
]"

end
