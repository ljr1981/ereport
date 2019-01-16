note
	description: "Summary description for {PDF_CATALOG}."

class
	PDF_CATALOG

inherit
	PDF_INDIRECT_OBJECT
		redefine
			default_create
		end

create
	make,
	make_with_pages

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
			-- `dictionary' creation and basic /Type /Catalog setting.
		local
			l_value: TUPLE [PDF_NAME, PDF_OBJECT [detachable ANY]]
		do
			Precursor
			create dictionary
			dictionary.add_object (type)
			add_object (dictionary)
			l_value := [create {PDF_NAME}.make ("Type"), create {PDF_NAME}.make ("Catalog")]
			type.set_value (l_value)
		end

	make (a_pages_ref, a_outlines_ref: PDF_OBJECT_REFERENCE)
			-- `make' with `a_pages_ref' and `a_outlines_ref'.
		do
			default_create

			create outlines.make_as_obj_ref ("Outlines", a_outlines_ref)
			check has_pages: attached outlines as al_outlines then
				dictionary.add_object (al_outlines)
			end

			create pages.make_as_obj_ref ("Pages", a_pages_ref)
			check has_pages: attached pages as al_pages then
				dictionary.add_object (al_pages)
			end
		end

	make_with_pages (a_pages_ref: PDF_OBJECT_REFERENCE)
			-- `make_with_pages' of `a_pages_ref'.
		do
			default_create

			create pages.make_as_obj_ref ("Pages", a_pages_ref)
			check has_pages: attached pages as al_pages then
				dictionary.add_object (al_pages)
			end
		end

feature -- Access

	type: PDF_KEY_VALUE_NAME
			-- Key (Type) Value (Catalog) pair.
		attribute
			create Result.make ("Type", "Catalog")
		end

	dictionary: PDF_DICTIONARY_GENERAL
			-- Contains a `dictionary'.

	pages: detachable PDF_KEY_VALUE
			-- Has possible `pages'.

	outlines: detachable PDF_KEY_VALUE
			-- Has possible `outlines'.

;note
	main_spec: "7.7.2 Document Catalog"
	other_specs: "4.8, 7.5.2, Table 15 Trailer Dictionary Root"

end
