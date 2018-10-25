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
			assert_integers_equal ("pdf_boolean_length", 4, l_item.pdf_out_count)
			assert_strings_equal ("pdf_boolean_hex_length", "00000004", l_item.length_hex)
		end

	test_sample_pdf_decimal
			-- test
		local
			l_item: PDF_DECIMAL
		do
			create l_item.make_with_integer (999_888_777)
			assert_strings_equal ("pdf_decimal_true", "999888777", l_item.pdf_out)
			assert_integers_equal ("pdf_decimal_length", 9, l_item.pdf_out_count)
			assert_strings_equal ("pdf_decimal_hex_length", "00000009", l_item.length_hex)
		end

	test_sample_pdf_integer
			-- test
		local
			l_item: PDF_INTEGER
		do
			create l_item.make_with_integer (999_888_777)
			assert_strings_equal ("pdf_integer_true", "999888777", l_item.pdf_out)
			assert_integers_equal ("pdf_integer_length", 9, l_item.pdf_out_count)
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
			assert_integers_equal ("pdf_integer_length", 23, l_item.pdf_out_count)
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
			assert_integers_equal ("pdf_string_length", 50, l_item.pdf_out_count)
			assert_strings_equal ("pdf_string_hex_length", "00000032", l_item.length_hex)

			create l_item.make_as_hex (<<('a').code, ('b').code, ('c').code>>)
			assert_strings_equal ("hex_pdf_out", "<616263>", l_item.pdf_out)

			create l_item.make_as_hex (l_item.string_to_hex ("abc"))
			assert_strings_equal ("hex_pdf_out_2", "<616263>", l_item.pdf_out)
		end

	pdf_stream_text_object_test
			--
		local
			l_item: PDF_STREAM_PLAIN_TEXT_OBJECT
		do
			create l_item.make_with_entries (<<["", 0, 0, 0, ""]>>)
			l_item.set_object_number (1)
			assert_strings_equal ("stream_object_text", stream_object_text, l_item.pdf_out)
		end

------------------------------------

	stream_object_text: STRING = "[
1 0 obj
<<
/Length 26
>>
stream
BT
/ 0 Tf
0 0 Td
() Tj
ET

endstream
endobj

]"

------------------------------------

	pdf_stream_test
			-- Test of PDF_STREAM_PLAIN_TEXT_OBJECT
		local
			l_item: PDF_STREAM_PLAIN_TEXT_OBJECT
			l_font: PDF_FONT
		do
			create l_font.make_with_font_info ("F1", "subtype", "basefontname", "encodings")
			create l_item.make_with_entries (<<[l_font.name_value, 20, 120, 120, "Hello from Steve"]>>)
			l_item.set_object_number (1)

			assert_strings_equal ("stream_text", stream_result_text, l_item.pdf_out)
		end

------------------------------------

	stream_result_text: STRING = "[
1 0 obj
<<
/Length 49
>>
stream
BT
/F1 20 Tf
120 120 Td
(Hello from Steve) Tj
ET

endstream
endobj

]"

------------------------------------

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
			l_dict: PDF_DICTIONARY_GENERAL
			l_but_got: STRING
		do
			create l_body
			create l_item
			create l_dict
			l_dict.add_object (create {PDF_KEY_VALUE}.make_as_name ("Key", "Value"))
			l_item.set_object_number (1)
			l_item.add_object (l_dict)
			assert_strings_equal ("indirect_object_1", indirect_object_text, l_item.pdf_out)
			l_body.add_object (l_item)

			l_but_got := l_body.pdf_out.twin
			l_but_got.replace_substring_all ("%R", "")
			assert_strings_equal ("body_1", body_text, l_but_got)
		end

-----------------------------------------------
	indirect_object_text: STRING = "[
1 0 obj
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
xref
0 1
0000000000 65535 f
0000000033 00000 n

]"
-----------------------------------------------

	pdf_document_test
		local
			l_doc: PDF_DOCUMENT

			l_ind_5: PDF_INDIRECT_OBJECT

			l_page_4: PDF_PAGE
			l_pages_3: PDF_PAGE_TREE [PDF_PAGE]
			l_outlines_2: PDF_OUTLINES
			l_catalog_1: PDF_CATALOG

			l_dic_5: PDF_DICTIONARY_GENERAL

			l_but_got: STRING
		do
			create l_doc
			l_doc.header.set_version (4)

			create l_ind_5; create l_dic_5; l_ind_5.add_object (l_dic_5)

			create l_page_4.make (l_ind_5.ref, [0, 0, 612, 792])
			create l_pages_3.make_with_kids (<<l_page_4.ref>>)
			create l_outlines_2
			create l_catalog_1.make (l_pages_3.ref, l_outlines_2.ref)

			l_doc.body.add_object (l_catalog_1)
			l_doc.body.add_object (l_outlines_2)
			l_doc.body.add_object (l_pages_3)
			l_doc.body.add_object (l_page_4)
			l_doc.body.add_object (l_ind_5)

			l_but_got := l_doc.pdf_out.twin
			l_but_got.replace_substring_all ("%R", "")
			assert_strings_equal ("doc", doc_text, l_but_got)
		end

---------------------------------------
	doc_text: STRING = "[
%PDF-1.4
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
/Count 1
/Type /Pages
/Kids [4 0 R]
>>
endobj
4 0 obj
<<
/Type /Page
/Contents 5 0 R
/MediaBox [0 0 612 792]
/Parent 3 0 R
>>
endobj
5 0 obj
<<
>>
endobj
xref
0 5
0000000000 65535 f
0000000065 00000 n
0000000111 00000 n
0000000168 00000 n
0000000255 00000 n
0000000276 00000 n
trailer
<<
/Size 6
/Root 1 0 R
>>
startxref
276
%%EOF
]"
-----------------------------

	pdf_xref_line_test
		local
			l_item: PDF_XREF_IND_OBJ_LINE
		do
			create l_item
			l_item.set_line_offset (999)
			assert_strings_equal ("line_offset", "0000000999 00000 n%R%N", l_item.line)
			l_item.set_generation_value (1024)
			assert_strings_equal ("generation_1", "0000000999 01024 n%R%N", l_item.line)
			l_item.set_generation_value (65535)
			assert_strings_equal ("generation_2", "0000000999 65535 n%R%N", l_item.line)
			l_item.set_free
			assert_strings_equal ("free", "0000000999 65535 f%R%N", l_item.line)
			l_item.set_in_use
			assert_strings_equal ("in_use", "0000000999 65535 n%R%N", l_item.line)
		end

feature {NONE} -- Test Support: In-system References

	pdf_doc: detachable PDF_DOCUMENT
	pdf_header: detachable PDF_HEADER
	pdf_body: detachable PDF_BODY
	pdf_xref: detachable PDF_XREF_TABLE
	pdf_xref_line: detachable PDF_XREF_IND_OBJ_LINE
	pdf_trailer: detachable PDF_TRAILER

	pdf_comment: detachable PDF_COMMENT

	pdf_boolean: detachable PDF_BOOLEAN
	pdf_integer: detachable PDF_INTEGER
	pdf_decimal: detachable PDF_DECIMAL
	pdf_string: detachable PDF_STRING

	pdf_name: detachable PDF_NAME

	pdf_container: detachable PDF_OBJECT_CONTAINER
	pdf_dictionary: detachable PDF_DICTIONARY_GENERAL
	pdf_indirect: detachable PDF_INDIRECT_OBJECT

feature -- Tests: PDF Document

	sample_pdf_generation_test
			-- General a very simple sample text-based PDF file content.
		note
			design: "[
				The document (below) is built from specific-to-general.
				The document presumes a single font, single page, with
				single resources. This is as basic as it can get.
				
				PROCESS
				=======
				
				Start with defining fonts.
				Next, define the text with font references and parameters.
				Next, give the text and fonts to a page.
				Next, give the page (as a ref) to a page-tree collection.
				Next, give the page-tree to a doc-catalog.
				Finally, create the document and give each element
					to it in top-down order.
					
				WHAT YOU GET FOR YOUR TROUBLE!
				==============================
				
				What is produced is the coded specifications for a PDF file.
				You can take what is generated, save it to a file and then
				open it up (e.g. open the PDF file in Windows Explorer).
				
				See the corresponding file created by this test routine.
				]"
		local
			l_doc: PDF_DOCUMENT

			l_stream_5: PDF_STREAM_PLAIN_TEXT_OBJECT
			l_font_4,
			l_font_4b: PDF_FONT
			l_font_4_ref_key_value: PDF_KEY_VALUE
			l_page_3: PDF_PAGE
			l_pages_2: PDF_PAGE_TREE [PDF_PAGE]
			l_catalog_1: PDF_CATALOG
			l_but_got: STRING

			l_file: PLAIN_TEXT_FILE
		do
				-- Obj 4 - FONTS
			create l_font_4.make_with_font_info ("F1", "Type1", "Helvetica", "StandardEncoding")
			create l_font_4b.make_with_font_info ("F2", "Type1", "CourierNew", "StandardEncoding")

				-- Obj 5 - TEXT (using FONT)
			create l_stream_5.make_with_entries (<<[l_font_4.name_value, 20, 120, 120, "See {PDF_TEST_SET}.sample_pdf_generation_test"]>>)

				-- Obj 3 - PAGE (w/TEXT.ref, RECT, FONT)
			create l_page_3.make_with_fonts (l_stream_5.ref, [0, 0, 612, 792], <<l_font_4, l_font_4b>>)

				-- Obj 2 - PAGES
			create l_pages_2.make_with_kids (<<l_page_3.ref>>)

				-- Obj 1 - CATALOG (dictionary)
			create l_catalog_1.make_with_pages (l_pages_2.ref)

				-- Build PDF Document from elements above
			create l_doc
			l_doc.header.set_version (4)

			l_doc.body.add_object (l_catalog_1)
			l_doc.body.add_object (l_pages_2)
			l_doc.body.add_object (l_page_3)
			l_doc.body.add_object (l_font_4)
			l_doc.body.add_object (l_font_4b)
			l_doc.body.add_object (l_stream_5)

			l_but_got := l_doc.pdf_out.twin				-- Must do this because %R is a part of
			l_but_got.replace_substring_all ("%R", "")	-- the Xref spec for EOL on each table line.
			assert_strings_equal ("sample_pdf", sample_pdf, l_but_got)

			create l_file.make_create_read_write (".\tests\assets\generated_sample.pdf")
			l_file.put_string (l_doc.pdf_out)
			l_file.close
		end

feature {NONE} -- Test Support: PDF

	sample_pdf: STRING = "[
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
/Basefont /Helvetica
/Encoding /StandardEncoding
>>
endobj
5 0 obj
<<
/Type /Font
/Name /F2
/Subtype /Type1
/Basefont /CourierNew
/Encoding /StandardEncoding
>>
endobj
6 0 obj
<<
/Length 78
>>
stream
BT
/F1 20 Tf
120 120 Td
(See {PDF_TEST_SET}.sample_pdf_generation_test) Tj
ET

endstream
endobj
xref
0 6
0000000000 65535 f
0000000049 00000 n
0000000106 00000 n
0000000264 00000 n
0000000372 00000 n
0000000481 00000 n
0000000609 00000 n
trailer
<<
/Size 7
/Root 1 0 R
>>
startxref
609
%%EOF
]"

end
