note
	description: "Abstraction of {PDF_PAGE_GENERAL}."
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

deferred class
	PDF_PAGE_GENERAL

inherit
	PDF_INDIRECT_OBJECT
		redefine
			set_parent_ref,
			pdf_out
		end

feature -- Access

	resources: detachable PDF_KEY_VALUE
			-- Page `resources' (ex: fonts, etc).

	resources_dictionary: detachable PDF_DICTIONARY_GENERAL
			-- The `resources_dictionary' contained in `resources'.

feature {NONE} -- Implementation: Access

	type: PDF_KEY_VALUE
			-- /Type /Page
		attribute
			create Result.make_as_name ("Type", "Page")
		end

	dictionary: PDF_DICTIONARY_GENERAL
			-- Page `dictionary'.

	media_box: detachable PDF_KEY_VALUE
			-- Page `media_box'.

	contents: PDF_KEY_VALUE
			-- Page `contents'.

	font: PDF_KEY_VALUE
			-- Page `font' /Font <<dictionary>>.
		attribute
			create Result
		end

feature -- Settings

	init_resources
			-- Initialize `resources'.
		note
			design: "[
				This routine makes a lot of basic assumptions about the page.
				For example: Presumes the page has nothng but PDF Text.
				]"
		require
			no_res: not attached resources
			no_dict: not attached resources_dictionary
		local
			l_procset_array: PDF_ARRAY
		do
			create resources_dictionary
			check has_dict: attached resources_dictionary as al_dict then
					-- /ProcSet [/PDF /Text]
				create l_procset_array
				l_procset_array.add_item (create {PDF_KEY_VALUE}.make_as_name ("PDF", "Text"))
				al_dict.add_object (create {PDF_KEY_VALUE}.make_as_array ("ProcSet", l_procset_array))
					-- Continue
				create resources.make_as_dictionary ("Resources", al_dict)
				check has_res: attached resources as al_res then
					dictionary.add_object (al_res)
				end
			end
		ensure
			has_res: attached resources
			has_dict: attached resources_dictionary
		end

	set_font_reference (a_fonts: ARRAY [PDF_FONT])
			-- Set a Font obj ref into `resources_dictionary'
		note
			design_warning: "[
				Presumes there is but one font for the entire page. This will not
				be the case for more complex documents, so this class and its features
				are based on simplistic single-font text-only notions for the moment.
				]"
		local
			l_dict: PDF_DICTIONARY_GENERAL
			l_fonts: ARRAYED_LIST [PDF_KEY_VALUE]
		do
			create l_fonts.make (a_fonts.count)
			across
				a_fonts as ic_fonts
			loop
				l_fonts.force (create {PDF_KEY_VALUE}.make_as_obj_ref (ic_fonts.item.name_value, ic_fonts.item.ref))
			end
			create l_dict
			l_dict.set_from_array (l_fonts.to_array)
			set_font (l_dict)
		end

feature {NONE} -- Implementation: Settings

	set_font (a_dict: PDF_DICTIONARY_GENERAL)
			-- `set_font' of `a_dict' into `resources_dictionary'.
		require
			has_resources: attached resources
			has_resources_dictionary: attached resources_dictionary
		do
			create font.make_as_dictionary ("Font", a_dict)
			check has_font: attached font as al_font and then attached resources_dictionary as al_dict then
				al_dict.add_object (al_font)
			end
		ensure
			has_font: attached font as al_font
			in_dict: attached resources_dictionary as al_res_dict and then
						attached al_res_dict.objects as al_objects and then
						al_objects.has (al_font)
		end

	set_media_box (obj: attached like media_box)
			-- `set_media_box' to `obj' (`media_box').
		do
			media_box := obj
		end

	init_media_box (llx, lly, urx, ury: STRING)
			-- Initialize the media box with lower-left and upper-right x,y's.
		local
			l_box: PDF_RECTANGLE
		do
			create l_box.make (llx, lly, urx, ury)
			check has: attached l_box as al_box then
				create media_box.make_as_array ("MediaBox", l_box)
			end
		end

	set_parent_ref (a_ref: attached like parent_ref)
			-- <Precursor>
		do
			Precursor (a_ref)
			check has_ref: attached parent_ref as al_ref then
				dictionary.add_object (create {PDF_KEY_VALUE}.make_as_obj_ref ("Parent", al_ref))
			end
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

feature {NONE} -- Implementation: Constants: MediaBox

	width_pixels: INTEGER
			-- Pixel width of 8 1/2" @ 72 dpi = 612 pixels.
		deferred
		end

	height_pixels: INTEGER
			-- Pixel width of 11" @ 72 dpi = 792 pixels.
		deferred
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			Result := Precursor
			if Result [Result.count] = ' ' then Result.remove_tail (1) end
		end

end
