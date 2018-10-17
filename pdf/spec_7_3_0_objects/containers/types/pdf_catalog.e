note
	description: "Summary description for {PDF_CATALOG}."

class
	PDF_CATALOG

inherit
	PDF_DICTIONARY

create
	make_with_refs

feature {NONE} -- Initialization

	make_with_refs (a_pages_ref, a_outlines_ref: PDF_OBJECT_REFERENCE)
			--
		do
			make_with_outlines ("Catalog", a_pages_ref, a_outlines_ref)
		end

end
