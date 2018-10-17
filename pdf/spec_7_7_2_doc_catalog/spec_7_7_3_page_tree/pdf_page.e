note
	description: "Summary description for {PDF_PAGE}."

class
	PDF_PAGE

inherit
	PDF_INDIRECT_OBJECT
		redefine
			set_parent_ref,
			pdf_out
		end

create
	make

feature {NONE} -- Initialization

	make (a_contents_ref: PDF_OBJECT_REFERENCE; a_media_box: TUPLE [llx, lly, urx, ury: STRING]; a_resources_dict: detachable PDF_DICTIONARY)
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

feature -- Access

	type: PDF_KEY_VALUE
			--
		attribute
			create Result.make_as_name ("Type", "Page")
		end

	dictionary: PDF_DICTIONARY

	media_box: detachable PDF_KEY_VALUE

	contents: PDF_KEY_VALUE

	resources: detachable ANY

feature -- Settings

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

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			Result := Precursor
		end

end
