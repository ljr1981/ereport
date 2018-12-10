note
	description: "[
			Abstract notion of a Content Stream Object Item
			]"
	design: "[
		Each item of Current is intended to be placed into a collection
		within a {PDF_STREAM_OBJECT}.
		]"

deferred class
	PDF_STREAM_OBJECT_ITEM

feature -- Access

	current_x, current_y: INTEGER

end
