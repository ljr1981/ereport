note
	description: "Summary description for {PDF_PAGE_TREE_NODE}."

class
	PDF_PAGE_TREE_NODE

inherit
	PDF_TOKEN

create
	make_root,
	make_with_parent

feature {NONE} -- Initialization

	make_root
			-- `make_root' (aka no `parent' dictionary).
		do
			parent := Void
			type.do_nothing
			kids.do_nothing
		ensure
			count = 0
			not attached parent
		end

	make_with_parent (a_parent: like Current)
			-- `make_with_parent' of `a_parent'
		do
			make_root
			parent := a_parent
		ensure
			has_parent: attached parent
		end

feature -- Access

	type: PDF_NAME
			--
		once ("OBJECT")
			create Result.make ("Pages")
		end

	parent: detachable PDF_PAGE_TREE_NODE
			-- "Dictionary" (aka {PDF_PAGE_TREE_NODE}).

	kids: ARRAYED_LIST [PDF_PAGE_TREE_NODE]
			-- Direct children of Current.
		attribute
			create Result.make (10)
		end

	count: INTEGER
			-- `count' of all {PDF_PAGE_OBJECT} items at or below Current.
		do
			across
				kids as ic
			loop
				if attached {PDF_PAGE_OBJECT} ic.item then
					Result := Result + 1
					Result := Result + ic.item.count
				end
			end
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			across
				kids as ic
			loop
				Result.append_string_general (ic.item.pdf_out)
			end
		end

end
