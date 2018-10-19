note
	description: "Representation of a {PDF_PAGE_US}."

class
	PDF_PAGE_US

inherit
	PDF_PAGE_GENERAL

create
	make_with_contents

feature {NONE} -- Initialization

	make_with_contents (a_contents_ref: PDF_OBJECT_REFERENCE; a_font_array: ARRAY [PDF_FONT])
			-- `make_with_contents' with `a_contents_ref'.
		note
			design: "[
				Ex: Contents might be text and the mediabox is square area
					of the page where the text will be drawn. Further, the
					media area might be /MediaBox [0 0 612 792] for 8.5 x 11 page.
					This size is 72 dpi (e.g. 612 / 8.5 = 72 dpi & 792 / 11 = 72 dpi)
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
			init_resources
			set_font_reference (a_font_array)
		end

feature {NONE} -- Implementation: Constants: MediaBox

	width_pixels: INTEGER = 612
			-- Pixel width of 8 1/2" @ 72 dpi = 612 pixels.

	height_pixels: INTEGER = 792
			-- Pixel width of 11" @ 72 dpi = 792 pixels.

;note
	goal: "[
		Represent a function 8 1/2 inch x 11 inch US page in
		portrait layout.
		]"

end
