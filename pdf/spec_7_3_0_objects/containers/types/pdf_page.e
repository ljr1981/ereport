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

class
	PDF_PAGE

inherit
	PDF_INDIRECT_OBJECT
		redefine
			set_parent_ref,
			pdf_out
		end

create
	make,
	make_with_font

feature {NONE} -- Initialization

	make (a_contents_ref: PDF_OBJECT_REFERENCE;
				a_media_box: TUPLE [llx, lly, urx, ury: STRING])
			--
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

	make_with_font (a_contents_ref: PDF_OBJECT_REFERENCE;
				a_media_box: TUPLE [llx, lly, urx, ury: STRING];
				a_font: PDF_FONT)
			--
		do
			make (a_contents_ref, a_media_box)
			init_resources
			set_font_reference (a_font.name_value, a_font)
		end

feature -- Access

	resources: detachable PDF_KEY_VALUE

	resources_dictionary: detachable PDF_DICTIONARY

feature {NONE} -- Implementation: Access

	type: PDF_KEY_VALUE
			--
		attribute
			create Result.make_as_name ("Type", "Page")
		end

	dictionary: PDF_DICTIONARY

	media_box: detachable PDF_KEY_VALUE

	contents: PDF_KEY_VALUE

	font: detachable PDF_KEY_VALUE

feature -- Settings

	init_resources
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

	set_font_reference (a_ref_name: STRING; a_font: PDF_FONT)
			-- Set a Font obj ref into `resources_dictionary'
		local
			l_dict: PDF_DICTIONARY
		do
			create l_dict
			l_dict.set_from_array (<<create {PDF_KEY_VALUE}.make_as_obj_ref (a_ref_name, a_font.ref)>>)
			set_font (l_dict)
		end

feature {NONE} -- Implementation: Settings

	set_parent_ref (a_ref: attached like parent_ref)
			-- <Precursor>
		do
			Precursor (a_ref)
			check has_ref: attached parent_ref as al_ref then
				dictionary.add_object (create {PDF_KEY_VALUE}.make_as_obj_ref ("Parent", al_ref))
			end
		end

	set_media_box (obj: attached like media_box)
			--
		do
			media_box := obj
		end

	init_media_box (llx, lly, urx, ury: STRING)
		local
			l_box: PDF_RECTANGLE
		do
			create l_box.make (llx, lly, urx, ury)
			check has: attached l_box as al_box then
				create media_box.make_as_array ("MediaBox", l_box)
			end
		end

	set_font (a_dict: PDF_DICTIONARY)
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

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			Result := Precursor
		end

end
