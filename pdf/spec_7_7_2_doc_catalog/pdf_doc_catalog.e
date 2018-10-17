note
	description: "Summary description for {PDF_DOC_CATALOG}."

class
	PDF_DOC_CATALOG

inherit
	PDF_ANY

feature -- Access

	page_tree: PDF_PAGE_TREE
			-- 
		attribute
			create Result
		end

	outline_heirarchy: ARRAYED_LIST [detachable ANY] -- PDF_OUTLINE_ENTRY
			--
		attribute
			create Result.make (10)
		end

	article_threads: ARRAYED_LIST [detachable ANY] -- PDF_THREAD
			--
		attribute
			create Result.make (10)
		end

	named_destinations: detachable ANY

	interactive_form: detachable ANY

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
		end

end
