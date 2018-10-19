note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	PDF_STREAM_TEST_SET

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
			l_font_4a,
			l_font_4b: PDF_FONT
			l_font_4_ref_key_value: PDF_KEY_VALUE
			l_page_3: PDF_PAGE
			l_pages_2: PDF_PAGE_TREE
			l_catalog_1: PDF_CATALOG
			l_but_got: STRING

			l_file: PLAIN_TEXT_FILE
		do
				-- Obj 4 - FONTS
			create l_font_4a.make_with_font_info ("F1", "Type1", "Helvetica", "MacRomanEncoding")
			create l_font_4b.make_with_font_info ("F2", "Type1", "CourierNew", "MacRomanEncoding")

				-- Obj 5 - TEXT (using FONT)
			create l_stream_5.make_with_text ("See {PDF_TEST_SET}.sample_pdf_generation_test")
			l_stream_5.set_tf_font_ref_and_size (l_font_4a, 20)
			l_stream_5.set_td_offsets (120, 120)

				-- Obj 3 - PAGE (w/TEXT.ref, RECT, FONT)
			create l_page_3.make_with_font (l_stream_5.ref, ["0", "0", "612", "792"], <<l_font_4a>>)

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
			l_doc.body.add_object (l_font_4a)
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
/BaseFont /Helvetica
/Encoding /MacRomanEncoding
>>
endobj
5 0 obj
<<
/Type /Font
/Name /F2
/Subtype /Type1
/BaseFont /CourierNew
/Encoding /MacRomanEncoding
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
0000000254 00000 n
0000000362 00000 n
0000000471 00000 n
0000000599 00000 n
trailer
<<
/Size 7
/Root 1 0 R
>>
startxref
599
%%EOF
]"

end


