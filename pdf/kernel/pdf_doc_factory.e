note
	description: "Representation of a {PDF_DOC_FACTORY}."

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

	streams: ARRAYED_LIST [like new_stream_ind_obj]
			-- List of `streams' to generate.
		attribute
			create Result.make (10)
		end

	new_stream_ind_obj: TUPLE [ length: INTEGER; entries: ARRAYED_LIST [like new_stream_entry] ]
			-- Make one and give to caller.
		do
			create Result
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

	new_font_ind_obj: TUPLE [name, subtype, basefont, encoding: STRING; size: INTEGER]
			-- Make one and give to caller.
		do
			create Result
		end

feature -- Basic Operations

	build (a_text_blocks: ARRAY [TUPLE [text, basefont: STRING; size: INTEGER]])
		local
			l_blocks: ARRAYED_LIST [TUPLE [text, basefont: STRING; size: INTEGER; font: detachable like new_font_ind_obj; page: detachable like new_page_ind_obj; stream: detachable like new_stream_ind_obj]]
			l_new_font: like new_font_ind_obj
			l_new_page: attached like new_page_ind_obj
			l_new_stream: attached like new_stream_ind_obj
			l_new_entry: attached like new_stream_entry
			l_used_y: INTEGER
			l_media_box: TUPLE [llx, lly, urx, ury: INTEGER]
			l_block_sizings: TUPLE [width: INTEGER_32; height: INTEGER_32; left_offset: INTEGER_32; right_offset: INTEGER_32]
		do
				-- Prep work
			create l_blocks.make (a_text_blocks.count)
			across a_text_blocks as ic loop
				l_blocks.force ([ic.item.text, ic.item.basefont, ic.item.size, Void, Void, Void])
			end
			l_media_box := [0, 0, 612, 792]

				-- O3-1
			create catalog_ind_obj

				-- O3-2
			catalog_ind_obj.pages := page_tree_ind_obj
			page_tree_ind_obj.kids := (create {ARRAYED_LIST [attached like new_page_ind_obj]}.make (10))

				-- O3-3
			across
				l_blocks as ic_blocks
			loop
				l_new_font := new_font (ic_blocks.cursor_index, ic_blocks.item.basefont, ic_blocks.item.size)
				put_new_font (ic_blocks.item, l_new_font)
			end

				-- O3-4a
			across
				l_blocks as ic_blocks
			from
					-- O3-4
					-- Prep-work
				l_new_page := new_page_ind_obj; put_new_page (l_new_page)
				l_new_stream := new_stream_ind_obj; put_new_stream (l_new_stream)
				l_used_y := 0
			loop
				across
					ic_blocks.item.text.split ('%N') as ic_line
				loop
					l_block_sizings := block_sizings (ic_line.item, ic_blocks.item.size)
					l_new_entry := new_stream_entry
					check has_font: attached ic_blocks.item.font as al_font then
						l_new_entry.tf_font_name := al_font.name
						l_new_entry.tf_font_size := al_font.size
					end
					l_new_entry.td_x := 0
					l_new_entry.tj_text := ic_line.item
					if is_room_for_another (l_media_box.ury, l_block_sizings.height, l_used_y) then
						l_new_entry.td_y := -(l_block_sizings.height)
						l_used_y := l_used_y + l_block_sizings.height
					else
						l_used_y := 0
						l_new_page := new_page_ind_obj; put_new_page (l_new_page)
						l_new_stream := new_stream_ind_obj; put_new_stream (l_new_stream)
					end
					put_new_stream_entry (l_new_stream, l_new_entry)
				end
			end

				-- O3-4b

				-- O3-4c

				-- O3-4d
		end

feature {NONE} -- Implementation: Basic Operations

	is_room_for_another (a_total_height, a_total_needed, a_total_used: INTEGER): BOOLEAN
			-- Is there room for `a_total_needed', given `a_total_height' less `a_total_used'?
		do
			Result := (a_total_height - a_total_used) > a_total_needed
		end

	new_font (a_index: INTEGER; a_basefont: STRING; a_point_size: INTEGER): like new_font_ind_obj
			-- Create a `new_font' with `a_index', `a_basefont', for `a_point_size'.
		do
			Result := new_font_ind_obj
			Result.name := Font_prefix + a_index.out
			Result.subtype := Subtype_type1
			Result.basefont := a_basefont
			Result.encoding := MacRomanEncoding
			Result.size := a_point_size
		end

	block_sizings (a_text: STRING; a_height: INTEGER): TUPLE [width: INTEGER_32; height: INTEGER_32; left_offset: INTEGER_32; right_offset: INTEGER_32]
			-- What is the `block_sizings' of `a_text' at `a_height' using {EV_FONT}?
		do
			Result := (create {EV_FONT}.make_with_values ({EV_FONT_CONSTANTS}.Family_modern, {EV_FONT_CONSTANTS}.Weight_regular, {EV_FONT_CONSTANTS}.Shape_regular, a_height)).string_size (a_text)
		end

	put_new_font (a_block_item: TUPLE [text, basefont: STRING; size: INTEGER; font: detachable like new_font_ind_obj; page: detachable like new_page_ind_obj; stream: detachable like new_stream_ind_obj];
					a_font: like new_font_ind_obj)
			-- Put `a_font' into `fonts' and set `a_block_item' "font" to `a_font'.
		do
			fonts.force (a_font, a_font.name)
			a_block_item.font := a_font -- assoc font with block-list item
		end

	put_new_page (a_page: attached like new_page_ind_obj)
			-- Put `a_page' into "kids" of `page_tree_ind_obj'.
			-- Synchronize "page_count" of `page_tree_ind_obj' to "kids.count" of same.
		do
			page_tree_ind_obj.kids.force (a_page)
			page_tree_ind_obj.page_count := page_tree_ind_obj.kids.count
		end

	put_new_stream (a_stream: like new_stream_ind_obj)
			-- Put an initialized `a_stream' into `streams'.
		do
			a_stream.entries := (create {ARRAYED_LIST [like new_stream_entry]}.make (10))
			streams.force (a_stream)
		end

	put_new_stream_entry (a_stream: like new_stream_ind_obj; a_entry: like new_stream_entry)
			-- Put `a_entry' into entries of `a_stream'.
		do
			a_stream.entries.force (a_entry)
		end

feature {NONE} -- Implementation: Constants

	Font_prefix: STRING = "F"
	Subtype_type1: STRING = "Type1"
	MacRomanEncoding: STRING = "MacRomanEncoding"

;note
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
