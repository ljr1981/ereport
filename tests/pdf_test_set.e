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

			create l_item.make_as_hex (<<('a').code, ('b').code, ('c').code>>)
			assert_strings_equal ("hex_pdf_out", "<616263>", l_item.pdf_out)

			create l_item.make_as_hex (l_item.string_to_hex ("abc"))
			assert_strings_equal ("hex_pdf_out_2", "<616263>", l_item.pdf_out)
		end

	pdf_header_test
		local
			l_item: PDF_HEADER
		do
			create l_item
			assert_strings_equal ("v1_0", "%%PDF-1.0", l_item.v1_0)
			assert_strings_equal ("v1_1", "%%PDF-1.1", l_item.v1_1)
			assert_strings_equal ("v1_2", "%%PDF-1.2", l_item.v1_2)
			assert_strings_equal ("v1_3", "%%PDF-1.3", l_item.v1_3)
			assert_strings_equal ("v1_4", "%%PDF-1.4", l_item.v1_4)
			assert_strings_equal ("v1_5", "%%PDF-1.5", l_item.v1_5)
			assert_strings_equal ("v1_6", "%%PDF-1.6", l_item.v1_6)
			assert_strings_equal ("v1_7", "%%PDF-1.7", l_item.v1_7)
		end

	pdf_indirect_object_test
			--
		local
			l_body: PDF_BODY
			l_item: PDF_INDIRECT_OBJECT
			l_dict: PDF_DICTIONARY
			l_string: PDF_STRING
		do
			create l_body
			create l_item
			create l_dict
			l_dict.add_object (create {PDF_KEY_VALUE}.make_as_name ("Key", "Value"))
			l_item.add_object (l_dict)
			assert_strings_equal ("indirect_object_1", indirect_object_text, l_item.pdf_out)
			l_body.add_object (l_item)
			assert_strings_equal ("body_1", body_text, l_body.pdf_out)
		end

-----------------------------------------------
	indirect_object_text: STRING = "[
0 0 obj
<<
/Key /Value

>>
 
endobj

]"

	body_text: STRING = "[
1 0 obj
<<
/Key /Value

>>
 
endobj

]"
-----------------------------------------------

	pdf_document_test
		local
			l_doc: PDF_DOCUMENT

			l_outlines: PDF_OUTLINES_DICTIONARY
			l_ind_1,
			l_ind_3,
			l_ind_4,
			l_ind_5,
			l_ind_6: PDF_INDIRECT_OBJECT

			l_catalog: PDF_CATALOG
			l_dic_3,
			l_dic_4,
			l_dic_5,
			l_dic_6: PDF_DICTIONARY

			l_nam: PDF_NAME
		do
			create l_doc
			l_doc.header.set_version (4)

			create l_outlines.make
			create l_ind_3; create l_dic_3; l_ind_3.add_object (l_dic_3)
			create l_ind_1; create l_catalog.make_with_refs (l_ind_3.ref, l_outlines.ref); l_ind_1.add_object (l_catalog)
			create l_ind_4; create l_dic_4; l_ind_4.add_object (l_dic_4)
			create l_ind_5; create l_dic_5; l_ind_5.add_object (l_dic_5)
			create l_ind_6; create l_dic_6; l_ind_6.add_object (l_dic_6)

			l_doc.body.add_object (l_ind_1)
			l_doc.body.add_object (l_outlines)
			l_doc.body.add_object (l_ind_3)
			l_doc.body.add_object (l_ind_4)
			l_doc.body.add_object (l_ind_5)
			l_doc.body.add_object (l_ind_6)

			assert_strings_equal ("doc", doc_text, l_doc.pdf_out)
		end

---------------------------------------
	doc_text: STRING = "[
1 0 obj
<<
/Type /Catalog
/Pages 3 0 R
/Outlines 2 0 R

>>
 
endobj
2 0 obj
<<
/Type /Outlines
/Count 0

>>
 
endobj
3 0 obj
<<

>>
 
endobj
4 0 obj
<<

>>
 
endobj
5 0 obj
<<

>>
 
endobj
6 0 obj
<<

>>
 
endobj

]"

feature {NONE} -- Test Support: In-system References

	pdf_doc: detachable PDF_DOCUMENT
	pdf_header: detachable PDF_HEADER
	pdf_body: detachable PDF_BODY
	pdf_xref: detachable PDF_XREF_TABLE
	pdf_trailer: detachable PDF_TRAILER

	pdf_comment: detachable PDF_COMMENT

	pdf_boolean: detachable PDF_BOOLEAN
	pdf_integer: detachable PDF_INTEGER
	pdf_decimal: detachable PDF_DECIMAL
	pdf_string: detachable PDF_STRING
	pdf_array: detachable PDF_ARRAY
	pdf_name: detachable PDF_NAME

	pdf_container: detachable PDF_OBJECT_CONTAINER
	pdf_dictionary: detachable PDF_DICTIONARY
	pdf_indirect: detachable PDF_INDIRECT_OBJECT

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
