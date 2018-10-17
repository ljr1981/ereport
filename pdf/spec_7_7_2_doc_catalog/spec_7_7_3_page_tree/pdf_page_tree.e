note
	description: "Summary description for {PDF_PAGE_TREE}."

class
	PDF_PAGE_TREE

feature -- Access

	kids: ARRAYED_LIST [PDF_PAGE_TREE_NODE]
			--
		attribute
			create Result.make (10)
		end

	type: PDF_NAME
		once ("OBJECT")
			create Result.make ("Pages")
		end

end
