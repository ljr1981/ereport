note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	PDF_MEDIA_BOX_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		redefine
			on_prepare
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

	FW_PROCESS_HELPER
		undefine
			default_create
		end

	PDF_CONSTANTS
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			do_nothing
		end

feature -- Test routines

	pdf_media_box_tests
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_mbox: PDF_MEDIA_BOX
			l_item: PDF_STREAM_ENTRY
		do
			create l_mbox
			create l_item.make_with_font (create {PDF_FONT}.make ("Fx"))
			l_mbox.move_to_top_left (l_item)
			assert_integers_equal ("top_x", 0, l_item.x)
			assert_integers_equal ("top_y", l_mbox.bounds.ury, l_item.y)
			assert_integers_equal ("Td_x_move", 0, l_item.td_x_move)
			assert_integers_equal ("Td_y_move", -792, l_item.td_y_move)
		end

end


