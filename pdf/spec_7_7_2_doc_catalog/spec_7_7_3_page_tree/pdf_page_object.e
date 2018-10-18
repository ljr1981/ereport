note
	description: "Summary description for {PDF_PAGE_OBJECT}."

deferred class
	PDF_PAGE_OBJECT

inherit
	PDF_PAGE_TREE_NODE

feature -- Access

	last_modified: detachable DATE_TIME
			--

	resources: detachable ANY
			-- dictionary

	media_box: detachable ANY
			-- rectangle

	crop_box: detachable ANY
			-- rectangle

	bleed_box: detachable ANY
			-- rectangle

	trim_box: detachable ANY
			-- rectangle

	art_box: detachable ANY
			-- rectangle

	box_color_info: detachable ANY
			-- dictionary

	contents: detachable ANY
			-- stream or array

	rotate: INTEGER
			-- integer

	group: detachable ANY
			-- dictionary

	thumb: detachable ANY
			-- stream

	b: detachable ANY
			-- array

	dur: INTEGER
			-- integer

	trans: detachable ANY
			-- dictionary

	annots: detachable ANY
			-- array

	aa: detachable ANY
			-- dictionary

	metadata: detachable ANY
			-- stream

	peice_info: detachable ANY
			-- dictionary

	struct_parents: detachable ANY
			-- integer

	id: detachable ANY
			-- byte string

	pz: detachable ANY
			-- integer

	separation_info: detachable ANY
			-- dictionary

	tabs: detachable ANY
			-- name

	template_instantiated: detachable ANY
			-- name

	pres_steps: detachable ANY
			-- dictionary

	user_unit: detachable ANY
			-- number

	vp: detachable ANY
			-- dictionary

;note
	main_spec: ""
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
