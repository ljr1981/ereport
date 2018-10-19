note
	description: "Representationof a {PDF_US_PAGE}."
	BNFE: "[
		Page ::=
			Page_dictionary
			
		Page_dictionary ::=
			Type_name						<-- /Type /Page
			Parent_ref						<-- Ref to parent {PDF_PAGE_TREE}
			Media_box_array					<-- [llx, lly, urx, ury] configuration
			Contents_stream_ref				<-- Reference to page contents (i.e. BT ... ET obj)
			Resources_dictionary			<-- /ProcSet and /Font configuration

		Resources_dictionary ::=
			ProcSet_array					<-- List of procedure protocols
			Font_dictionary					<-- List of font obj references
			
		ProcSet_array ::=
			Proc_name+						<-- /PDF and /Text
			
		Font_dictionary ::=
			Font_key_value_ref+				<-- Object reference to {PDF_INDIRECT_OBJECT} text stream items

		Example:
			<<
				/Type /Page
				/Parent 2 0 R
				/MediaBox [0 0 612 792]
				/Contents 5 0 R
				/Resources <<
					/ProcSet [/PDF /Text]
					/Font <<
						/F1 4 0 R
						/F2 5 0 R
						>>
					>>
			>>
		]"

class
	PDF_US_PAGE

inherit
	PDF_PAGE

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

feature {NONE} -- Implementation: Access: MediaBox

	portrait_box: TUPLE [llx, lly, urx, ury: STRING]
			-- `portrait_box' mediabox settings.
			-- Lower-left and Upper-right x and y.
		once
			Result := ["0", "0", width_pixels.out, height_pixels.out]
		end

	landscape_box: TUPLE [llx, lly, urx, ury: STRING]
			-- `landscape_box' mediabox settings.
			-- Lower-left and Upper-right x and y.
		once
			Result := ["0", "0", height_pixels.out, width_pixels.out]
		end

feature -- Settings: MediaBox

	set_portrait
			-- Set `media_box' as `portrait_box'.
		do
			init_media_box (portrait_box.llx, portrait_box.lly, portrait_box.urx, portrait_box.ury)
		end

	set_landscape
			-- Set `media_box' as `landscape_box'.
		do
			init_media_box (landscape_box.llx, landscape_box.lly, landscape_box.urx, landscape_box.ury)
		end

feature {NONE} -- Implementation: Constants: MediaBox

	width_pixels: INTEGER = 612
			-- Pixel width of 8 1/2" @ 72 dpi = 612 pixels.

	height_pixels: INTEGER = 792
			-- Pixel width of 11" @ 72 dpi = 792 pixels.

note
	goal: "[
		Represent a function 8 1/2 inch x 11 inch US page in
		portrait layout.
		]"

end
