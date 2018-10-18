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
		do
			Precursor
			create dictionary
			dictionary.add_object (type)
			add_object (dictionary)

		end

	make (a_pages_ref, a_outlines_ref: PDF_OBJECT_REFERENCE)
			-- `make' with `a_pages_ref' and `a_outlines_ref'.
		do
			default_create

			create pages.make_as_obj_ref ("Pages", a_pages_ref)
			check has_pages: attached pages as al_pages then
				dictionary.add_object (al_pages)
			end

			create outlines.make_as_obj_ref ("Outlines", a_outlines_ref)
			check has_pages: attached outlines as al_outlines then
				dictionary.add_object (al_outlines)
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

	type: PDF_KEY_VALUE
			-- Key (Type) Value (Catalog) pair.
		attribute
			create Result.make_as_name ("Type", "Catalog")
		end

	dictionary: PDF_DICTIONARY
			-- Contains a `dictionary'.

	pages: detachable PDF_KEY_VALUE
			-- Has possible `pages'.

	outlines: detachable PDF_KEY_VALUE
			-- Has possible `outlines'.

;note
	main_spec: "7.7.2 Document Catalog"
	other_specs: "4.8, 7.5.2, Table 15 Trailer Dictionary Root"
	EIS: "name=pdf_spec", "protocol=pdf", "src=C:\Users\LJR19\Documents\_Moonshot\moon_training\Training Material\Specifications\PDF\PDF32000_2008.pdf"

end
