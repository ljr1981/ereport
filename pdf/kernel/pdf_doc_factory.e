note
	description: "Representation of a {PDF_DOC_FACTORY}."
	design: "See end of class notes"

class
	PDF_DOC_FACTORY

feature -- Access: Catalog

	catalog_ind_obj: TUPLE [pages: attached like page_tree_ind_obj]
			-- Our single catalog object to generate.
		attribute
			create Result
		end

feature -- Access: Page Tree

	page_tree_ind_obj: TUPLE [page_count: INTEGER; kids: ARRAYED_LIST [attached like new_page_ind_obj] ]
			-- Our single page tree object to generate.
			-- List of kids (pages) to generate.
		attribute
			create Result
		end

feature -- Access: Page

	new_page_ind_obj: TUPLE [stream: like new_stream_ind_obj;
							fonts: like fonts;
							page_tree_parent_ref: ANY]
			-- Make one and give to caller.
		do
			create Result
		end

feature -- Access: Stream

	new_stream_ind_obj: TUPLE [ length: INTEGER; entries: ARRAYED_LIST [like new_stream_entry] ]
			-- Make one and give to caller.
		do
			create Result
			Result.entries := (create {ARRAYED_LIST [like new_stream_entry]}.make (10))
		end

	new_stream_entry: TUPLE [Tf_font_name: STRING;
							Tf_font_size: INTEGER;
							Td_x, Td_y: INTEGER;
							Tj_text: STRING]
			-- Tf_Td_Tj_item
			--/F1 20 Tf
			--120 120 Td
			--(See {PDF_TEST_SET}.sample_pdf_generation_test) Tj
		do
			create Result
		end

feature -- Access: Font

	fonts: HASH_TABLE [like new_font_ind_obj, STRING]
			-- List of `fonts' to generate.
		attribute
			create Result.make (10)
		end

	new_font_ind_obj: TUPLE [name, subtype, basefont, encoding: STRING]
			-- Make one and give to caller.
		do
			create Result
		end

feature {NONE} -- Implementation: Basic Operations

	is_room_for_another (a_total_height, a_total_needed, a_total_used: INTEGER): BOOLEAN
			-- Is there room for `a_total_needed', given `a_total_height' less `a_total_used'?
		do
			Result := (a_total_height - a_total_used - 50) > a_total_needed
		end

	new_font (a_index: INTEGER; a_basefont: STRING): like new_font_ind_obj
			-- Create a `new_font' with `a_index', `a_basefont', for `a_point_size'.
		local
			l_new_font: like new_font_ind_obj
		do
			if fonts.has (a_basefont) then
				check has_font: attached fonts.item (a_basefont) as al_new_font then Result := al_new_font end
			else
				Result := new_font_ind_obj
				Result.name := Font_prefix + a_index.out
				Result.subtype := Subtype_type1
				Result.basefont := a_basefont
				Result.encoding := StandardEncoding
			end
		end

	block_sizings (a_text: STRING; a_height: INTEGER): TUPLE [width: INTEGER_32; height: INTEGER_32; left_offset: INTEGER_32; right_offset: INTEGER_32]
			-- What is the `block_sizings' of `a_text' at `a_height' using {EV_FONT}?
		do
			Result := (create {EV_FONT}.make_with_values ({EV_FONT_CONSTANTS}.Family_modern, {EV_FONT_CONSTANTS}.Weight_regular, {EV_FONT_CONSTANTS}.Shape_regular, a_height)).string_size (a_text)
		end

	put_new_font (a_block_item: attached like text_block_expanded_anchor;
					a_font: like new_font_ind_obj)
			-- Put `a_font' into `fonts' and set `a_block_item' "font" to `a_font'.
		do
			fonts.force (a_font, a_font.basefont)
			a_block_item.font := a_font -- assoc font with block-list item
		end

	put_new_page (a_page: attached like new_page_ind_obj)
			-- Put `a_page' into "kids" of `page_tree_ind_obj'.
			-- Synchronize "page_count" of `page_tree_ind_obj' to "kids.count" of same.
		do
			page_tree_ind_obj.kids.force (a_page)
			page_tree_ind_obj.page_count := page_tree_ind_obj.kids.count
		end

	put_new_stream (a_page: like new_page_ind_obj; a_stream: like new_stream_ind_obj)
			-- Put an initialized `a_stream' into `streams'.
		do
			a_page.stream := a_stream
		end

	put_new_stream_entry (a_stream: like new_stream_ind_obj; a_entry: like new_stream_entry)
			-- Put `a_entry' into entries of `a_stream'.
		do
			a_stream.entries.force (a_entry)
		end

feature {NONE} -- Implementation: Constants

	Font_prefix: STRING = "F"
	Subtype_type1: STRING = "TrueType"
	StandardEncoding: STRING = "StandardEncoding"

feature -- Basic Operations

	generate_from_build
		local
			l_font: PDF_FONT
			l_fonts: ARRAYED_LIST [PDF_FONT]

			l_page_tree: PDF_PAGE_TREE [PDF_PAGE]

			l_page: PDF_PAGE
			l_pages: ARRAYED_LIST [PDF_PAGE]
			l_page_refs: ARRAYED_LIST [PDF_OBJECT_REFERENCE]

			l_stream: PDF_STREAM_PLAIN_TEXT_OBJECT
			l_streams: ARRAYED_LIST [PDF_STREAM_PLAIN_TEXT_OBJECT]
			l_catalog: PDF_CATALOG

			l_doc: PDF_DOCUMENT
		do
				-- List of PDF_FONT items
			create l_fonts.make (fonts.count)
			across
				fonts as ic_fonts
			loop
				create l_font.make_with_font_info (ic_fonts.item.name, ic_fonts.item.subtype, ic_fonts.item.basefont, ic_fonts.item.encoding)
				l_fonts.force (l_font)
			end
			check fonts_transferred: not fonts.is_empty implies (not l_fonts.is_empty and then l_fonts.count = fonts.count) end

				-- List of PDF_STREAM_PLAIN_TEXT_OBJECT items
			create l_streams.make (10)

				-- List of PDF_PAGE items
			check attached page_tree_ind_obj as al_page_tree then
				create l_pages.make (al_page_tree.kids.count)
				across
					catalog_ind_obj.pages.kids as ic_pages
				loop
					check has_stream: attached ic_pages.item.stream as al_stream then
						create l_stream.make_with_entries (al_stream.entries.to_array)
						l_streams.force (l_stream)
					end
					create l_page.make_with_fonts (l_stream.ref, [Bottom_x_starting_point.out, Bottom_y_starting_point.out, Page_x_width_us_8_x_11.out, Page_y_height_us_8_x_11.out], l_fonts.to_array)
					l_pages.force (l_page)
				end
				check page_tree_kids_loaded: catalog_ind_obj.pages.kids.count = l_pages.count end
			end

				-- PDF_PAGE_TREE
			create l_page_refs.make (l_pages.count)
			across l_pages as ic loop
				l_page_refs.force (ic.item.ref)
			end
			create l_page_tree.make_with_kids (l_page_refs.to_array)

				-- Catalog
			create l_catalog.make_with_pages (l_page_tree.ref)

				-- Document
			create l_doc
			l_doc.body.add_object (l_catalog)
			l_doc.body.add_object (l_page_tree)
			across l_pages as ic_page loop
				l_doc.body.add_object (ic_page.item)
			end
			across l_fonts as ic_font loop
				l_doc.body.add_object (ic_font.item)
			end
			across l_streams as ic_stream loop
				l_doc.body.add_object (ic_stream.item)
			end

			generated_pdf := l_doc
		end

	generated_pdf: detachable PDF_DOCUMENT

	generated_pdf_attached: attached like generated_pdf
			-- Attached version of `generated_pdf'
		do
			check has_pdf: attached generated_pdf as al_pdf then Result := al_pdf end
		end

	build_content (a_content: ARRAY [FW_ARRAY2_EXT [PDF_STREAM_ENTRY]])
			-- `build_content' in `a_content'.
		do

		end

	build (a_text_blocks: ARRAY [attached like text_block_anchor])
			--
		local
			l_blocks: ARRAYED_LIST [attached like text_block_expanded_anchor]
			l_new_font: like new_font_ind_obj
			l_new_page: attached like new_page_ind_obj
			l_new_stream: attached like new_stream_ind_obj
			l_new_entry: attached like new_stream_entry
			l_used_y,
			l_top: INTEGER
			l_is_top: BOOLEAN
--			l_media_box: TUPLE [llx, lly, urx, ury: INTEGER]
			l_block_sizings: TUPLE [width: INTEGER_32; height: INTEGER_32; left_offset: INTEGER_32; right_offset: INTEGER_32]
		do
				-- Prep work
			create l_blocks.make (a_text_blocks.count)
			across a_text_blocks as ic loop
				l_blocks.force ([ic.item.text, ic.item.basefont, ic.item.size, ic.item.starting_x, Void, Void, Void])
			end
			--media_box := [Bottom_x_starting_point, Bottom_y_starting_point, Page_x_width_us_8_x_11, Page_y_height_us_8_x_11]

				-- O3-1
			create catalog_ind_obj

				-- O3-2
			catalog_ind_obj.pages := page_tree_ind_obj
			page_tree_ind_obj.kids := (create {ARRAYED_LIST [attached like new_page_ind_obj]}.make (10))

				-- O3-3
			across
				l_blocks as ic_blocks
			loop
				l_new_font := new_font (ic_blocks.cursor_index, ic_blocks.item.basefont)
				put_new_font (ic_blocks.item, l_new_font)
			end

				-- O3-4a
			across
				l_blocks as ic_blocks
			from
					-- O3-4
					-- Prep-work
				-- O3-4b
				l_new_page := new_page_ind_obj; put_new_page (l_new_page)
				l_new_stream := new_stream_ind_obj; put_new_stream (l_new_page, l_new_stream)
				l_used_y := Used_y_points_starting_value
				l_top := Top_margin_y
				l_is_top := True
			loop
				across
					ic_blocks.item.text.split ('%N') as ic_line
				loop
					l_block_sizings := block_sizings (ic_line.item, ic_blocks.item.size)
					l_new_entry := new_stream_entry
					check has_font: attached ic_blocks.item.font as al_font then
						l_new_entry.tf_font_name := al_font.name
						l_new_entry.tf_font_size := ic_blocks.item.size
					end
					l_new_entry.tj_text := ic_line.item
					if is_room_for_another (media_box_obj.bounds.ury, l_block_sizings.height, l_used_y) then
						if l_is_top then
							l_new_entry.td_x := ic_blocks.item.starting_x
							l_new_entry.td_y := l_top
							l_is_top := False
						else
							l_new_entry.td_x := Move_x_straight_down
							l_new_entry.td_y := -(l_block_sizings.height + Height_adjustment)
						end
						l_used_y := l_used_y + l_block_sizings.height + Height_adjustment
					else
						l_used_y := Bottom_y_starting_point
						l_is_top := True
						if l_is_top then
							l_new_entry.td_x := ic_blocks.item.starting_x
							l_new_entry.td_y := l_top
							l_is_top := False
						else
							l_new_entry.td_x := Move_x_straight_down
							l_new_entry.td_y := -(l_block_sizings.height + Height_adjustment)
						end
						l_used_y := l_used_y + l_block_sizings.height + Height_adjustment
							-- O3-4d
						l_new_page := new_page_ind_obj; put_new_page (l_new_page)
							-- O3-4c
						l_new_stream := new_stream_ind_obj; put_new_stream (l_new_page, l_new_stream)
					end
					put_new_stream_entry (l_new_stream, l_new_entry)
				end
			end
		end

feature -- Basic Operations

	build_from_media_box_obj (a_table: FW_ARRAY2_EXT [PDF_STREAM_ENTRY])
			-- Build PDF Document from `media_box_obj'.
		do

		end

feature -- {NONE} -- Implementation: Media Box

	media_box_obj: PDF_MEDIA_BOX
			-- `media_box_obj' of Current.
		attribute
			create Result
		end

feature -- {NONE} -- Implementation: Basic Operations: Type Anchors

	text_block_anchor: detachable TUPLE [text, basefont: STRING; size, starting_x: INTEGER]
			-- Type anchor for blocks of text in a basefont and point size.

	text_block_expanded_anchor: detachable TUPLE [text, basefont: STRING; size, starting_x: INTEGER;
													font: detachable like new_font_ind_obj;
													page: detachable like new_page_ind_obj;
													stream: detachable like new_stream_ind_obj]
			-- Type anchor like `text_block_anchor', but with additional
			--	font, page, and stream storage to set during `build' process.

feature -- {NONE} -- Implementation: Basic Operations: Constants

	Height_adjustment: INTEGER = 5
	Move_x_straight_down: INTEGER = 0
	Bottom_y_starting_point: INTEGER = 0
	Bottom_x_starting_point: INTEGER = 0
	Left_margin_x: INTEGER = 36
	Top_margin_y: INTEGER = 748
	Page_x_width_us_8_x_11: INTEGER = 612
	Page_y_height_us_8_x_11: INTEGER = 792
	Used_y_points_starting_value: INTEGER = 0

invariant

note
	design: "[
ORDER OF OPERATIONS
===================
Given "blocks-of-text" (w/"font-info") items:
	Presume text lays in from top-to-bottom, starting on page-1 to page-n

1. Create Catalog
2. Create Page-tree
	a. Attach reference from catalog to page-tree
	b. Spin-up pages list array in page-tree
3. Create Fonts
	a. Cycle through text-blocks, creating `new_font_ind_obj' items and putting them in `fonts'
4. Create Streams + Pages
	a. Cyle through text-blocks, creating 'stream_ind_obj' items for each, with `new_font_ind_obj' references
	b. Create a `new_page_ind_obj' for each `new_stream_ind_obj', packing as many text-blocks into it as possble (given MediaBox size)
		i. For each text-block, compute starting position and size of text
		ii. Compute if text-block will fit in remaining MediaBox area (given possible previous text-block entries)
		iii. Place text-block if it will fit, otherwise ...
		iv. Do steps c. and d. below
		v. Generate a new page+stream combo
	c. Attach reference from page to stream
	d. Attach reference from page-tree to page and page-parent to page-tree

Catalog -> Page_tree
Page_tree -> Page+
Page -> Stream, Font+, Page_tree

1 = Catalog       (/Type, /Pages=Page_tree_ref)
2 = Page Tree     (/Type, /Count, /Kids=[Page_ref+])
3 = Page+         (/Type, /Contents=Stream_ref, /MediaBox=[nnnn],Resources_dict=<</ProcSet=[],/Font_dic=<</Fn=Font_ref+>> /Parent=Page_tree_ref >>)
4 = Font+         (/Type, /Name, /Subtype, /BaseFont, /Encoding)
5 = Stream+       (<</Length>>, stream_kw, BT_kw, Tf_Td_Tj_item+, ET_kw, endstream_kw)
6 = XRef          (xref_kw, ...)
7 = Trailer       (trailer_kw, /Size, /Root, startxref_kw, EOF)

	]"

end
