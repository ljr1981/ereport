note
	description: "Summary description for {PDF_PAGE}."
	example: "[
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
]"
	design_warning: "[
		This design was initially built on simple sample PDFs
		located in the PDF ISO specification document (see ecf root folder).
		Because the simple samples have but one page, and only
		a smattering of text, there was only a need for one font
		resource.
		]"
	TODO: "[
		Expand this class to incorporate the following:
		
		- lines from top to bottom (i.e. given a list of text lines,
			draw each line from top-of-page down to bottom).
		- paragraphs from top to bottom.
		- tables with headers, columns, and rows from page top-to-bottom.
		]"

class
	PDF_PAGE

inherit
	PDF_PAGE_GENERAL

create
	make,
	make_with_fonts

feature {NONE} -- Initialization

	make (a_contents_ref: PDF_OBJECT_REFERENCE;
				a_media_box: TUPLE [llx, lly, urx, ury: STRING])
			-- `make' with `a_contents_ref' and `a_media_box'.
		note
			design: "[
				Ex: Contents might be text and the mediabox is square area
					of the page where the text will be drawn. Further, the
					media area might be /MediaBox [0 0 612 792] for 8.5 x 11 page.
				]"
		do
			default_create

			create dictionary
			dictionary.add_object (type)
			add_object (dictionary)

			create contents.make_as_obj_ref ("Contents", a_contents_ref)
			check has_contents: attached contents as al_contents then
				dictionary.add_object (al_contents)
			end

			init_media_box (a_media_box.llx, a_media_box.lly, a_media_box.urx, a_media_box.ury)
			check has_box: attached media_box as al_box then
				dictionary.add_object (al_box)
			end
		end

	make_with_fonts (a_contents_ref: PDF_OBJECT_REFERENCE;
				a_media_box: TUPLE [llx, lly, urx, ury: STRING];
				a_font_array: ARRAY [PDF_FONT])
			-- `make_with_fonts' like `make', but with added font-info.
		do
			make (a_contents_ref, a_media_box)
			init_resources
			set_font_reference (a_font_array)
		end

feature {NONE} -- Implementation: Constants: MediaBox

	width_pixels: INTEGER = 612
			-- Pixel width of 8 1/2" @ 72 dpi = 612 pixels.

	height_pixels: INTEGER = 792
			-- Pixel width of 11" @ 72 dpi = 792 pixels.

;note
	main_spec: "7.7.3.3 Page Objects"
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
