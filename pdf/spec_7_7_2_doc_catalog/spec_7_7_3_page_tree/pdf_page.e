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

	make (a_contents_ref: PDF_OBJECT_REFERENCE; a_resources_dict: detachable PDF_DICTIONARY)
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
		end

feature -- Access

	type: PDF_KEY_VALUE
			--
		attribute
			create Result.make_as_name ("Type", "Page")
		end

	dictionary: PDF_DICTIONARY

	media_box: detachable ANY

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

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			Result := Precursor
		end

end
