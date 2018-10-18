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

;note
	main_spec: ""
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
