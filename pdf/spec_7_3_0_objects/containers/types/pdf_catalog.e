note
	description: "Summary description for {PDF_CATALOG}."

class
	PDF_CATALOG

inherit
	PDF_INDIRECT_OBJECT

create
	make

feature {NONE} -- Initialization

	make (a_pages_ref, a_outlines_ref: PDF_OBJECT_REFERENCE)
			--
		do
			default_create
			
			create dictionary
			dictionary.add_object (type)
			add_object (dictionary)

			create pages.make_as_obj_ref ("Pages", a_pages_ref)
			check has_pages: attached pages as al_pages then
				dictionary.add_object (al_pages)
			end

			create outlines.make_as_obj_ref ("Outlines", a_outlines_ref)
			check has_pages: attached outlines as al_outlines then
				dictionary.add_object (al_outlines)
			end
		end

feature -- Access

	type: PDF_KEY_VALUE
			--
		attribute
			create Result.make_as_name ("Type", "Catalog")
		end

	dictionary: PDF_DICTIONARY

	pages: detachable PDF_KEY_VALUE

	outlines: detachable PDF_KEY_VALUE

end
