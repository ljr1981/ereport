note
	description: "Representation of a {PDF_PAGE}."
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
	make_with_fonts,
	make_with_fonts_and_parent

feature {NONE} -- Initialization

	make (a_contents_ref: PDF_OBJECT_REFERENCE;
				a_media_box: TUPLE [llx, lly, urx, ury: INTEGER])
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
				a_media_box: TUPLE [llx, lly, urx, ury: INTEGER];
				a_font_array: ARRAY [PDF_FONT])
			-- `make_with_fonts' like `make', but with added font-info.
		do
			make (a_contents_ref, a_media_box)
			init_resources
			set_font_reference (a_font_array)
		end

	make_with_fonts_and_parent (a_contents_ref: PDF_OBJECT_REFERENCE;
				a_media_box: TUPLE [llx, lly, urx, ury: INTEGER];
				a_font_array: ARRAY [PDF_FONT];
				a_parent_obj: PDF_INDIRECT_OBJECT)
			-- `make_with_fonts_and_parent' like `make', but with added font-info.
		do
			default_create

			create dictionary
			dictionary.add_object (type)
			add_object (dictionary)

			create parent_ref.make_with_object (a_parent_obj)
			check has_parent_ref: attached parent_ref as al_parent_ref then
				dictionary.add_object (create {PDF_KEY_VALUE}.make_as_obj_ref ("Parent", al_parent_ref))
			end

			create contents.make_as_obj_ref ("Contents", a_contents_ref)
			check has_contents: attached contents as al_contents then
				dictionary.add_object (al_contents)
			end

			init_media_box (a_media_box.llx, a_media_box.lly, a_media_box.urx, a_media_box.ury)
			check has_box: attached media_box as al_box then
				dictionary.add_object (al_box)
			end

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

end
