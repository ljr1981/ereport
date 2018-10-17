note
	testing: "type/manual"

class
	PDF_ARRAY_TEST_SET

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

feature {NONE} -- Initialization

	on_prepare
			-- <Precursor>
		do
			do_nothing
		end

feature -- Test routines

	homogenous_array_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_ARRAY
		do
			create l_item
			l_item.add_item (create {PDF_BOOLEAN}.make_true)
			l_item.add_item (create {PDF_BOOLEAN}.make_false)
			l_item.add_item (create {PDF_DECIMAL}.make_with_string ("99.1"))
			l_item.add_item (create {PDF_DECIMAL}.make_with_string ("99.2"))
			l_item.add_item (create {PDF_INTEGER}.make_with_integer (1))
			l_item.add_item (create {PDF_INTEGER}.make_with_integer (2))
			l_item.add_item (create {PDF_KEY_VALUE}.make_as_name ("Key1", "Value1"))
			l_item.add_item (create {PDF_KEY_VALUE}.make_as_name ("Key1", "Value1"))
			l_item.add_item (create {PDF_NAME}.make ("one"))
			l_item.add_item (create {PDF_NAME}.make ("two"))
			l_item.add_item (create {PDF_OBJECT_REFERENCE}.make_with_object (create {PDF_INDIRECT_OBJECT}))
			l_item.add_item (create {PDF_OBJECT_REFERENCE}.make_with_object (create {PDF_INDIRECT_OBJECT}))
			l_item.add_item (create {PDF_RECTANGLE}.make ("1", "2", "3", "4"))
			l_item.add_item (create {PDF_RECTANGLE}.make ("100", "200", "300", "400"))
			l_item.add_item (create {PDF_STRING}.make_as_literal ("one"))
			l_item.add_item (create {PDF_STRING}.make_as_literal ("Two"))
			assert_strings_equal ("array_text", array_text, l_item.pdf_out)
		end

--------------------------------
	array_text: STRING = "[
[true false 99.1 99.2 1 2 /Key1 /Value1 /Key1 /Value1 /one /two 0 0 R 0 0 R [1 2 3 4 ] [100 200 300 400 ] (one) (Two) ]
]"
--------------------------------

	array_booleans_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_ARRAY_BOOLEANS
		do
			create l_item
			l_item.add_item (create {PDF_BOOLEAN}.make_true)
			l_item.add_item (create {PDF_BOOLEAN}.make_false)
			assert_strings_equal ("booleans_text", booleans_text, l_item.pdf_out)
		end

--------------------------------
	booleans_text: STRING = "[
[true false ]
]"
--------------------------------

	array_decimals_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_ARRAY_DECIMALS
		do
			create l_item
			l_item.add_item (create {PDF_DECIMAL}.make_with_string ("99.1"))
			l_item.add_item (create {PDF_DECIMAL}.make_with_string ("99.2"))
			assert_strings_equal ("decimals_text", decimals_text, l_item.pdf_out)
		end

--------------------------------
	decimals_text: STRING = "[
[99.1 99.2 ]
]"
--------------------------------

	array_dictionaries_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_ARRAY_DICTIONARIES
		do
			create l_item
			l_item.add_item (create {PDF_DICTIONARY})
			l_item.add_item (create {PDF_DICTIONARY})
			assert_strings_equal ("dictionaries_text", dictionaries_text, l_item.pdf_out)
		end

--------------------------------
	dictionaries_text: STRING = "[
[<<

>>
 <<

>>
 ]
]"
--------------------------------

	array_indirect_objects_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_ARRAY_INDIRECT_OBJECTS
		do
			create l_item
			l_item.add_item (create {PDF_INDIRECT_OBJECT})
			l_item.add_item (create {PDF_INDIRECT_OBJECT})
			assert_strings_equal ("indirect_objects_text", indirect_objects_text, l_item.pdf_out)
		end

--------------------------------
	indirect_objects_text: STRING = "[
[0 0 obj

endobj
 0 0 obj

endobj
 ]
]"
--------------------------------

	array_integers_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_ARRAY_INTEGERS
		do
			create l_item
			l_item.add_item (create {PDF_INTEGER}.make_with_integer (1))
			l_item.add_item (create {PDF_INTEGER}.make_with_integer (2))
			assert_strings_equal ("integers_text", integers_text, l_item.pdf_out)
		end

--------------------------------
	integers_text: STRING = "[
[1 2 ]
]"
--------------------------------

	array_key_values_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_ARRAY_KEY_VALUES
		do
			create l_item
			l_item.add_item (create {PDF_KEY_VALUE}.make_as_name ("Key1", "Value1"))
			l_item.add_item (create {PDF_KEY_VALUE}.make_as_name ("Key1", "Value1"))
			assert_strings_equal ("key_values_text", key_values_text, l_item.pdf_out)
		end

--------------------------------
	key_values_text: STRING = "[
[/Key1 /Value1 /Key1 /Value1 ]
]"
--------------------------------

	array_names_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_ARRAY_NAMES
		do
			create l_item
			l_item.add_item (create {PDF_NAME}.make ("one"))
			l_item.add_item (create {PDF_NAME}.make ("two"))
			assert_strings_equal ("names_text", names_text, l_item.pdf_out)
		end

--------------------------------
	names_text: STRING = "[
[/one /two ]
]"
--------------------------------

	array_object_references_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_ARRAY_OBJECT_REFERENCES
		do
			create l_item
			l_item.add_item (create {PDF_OBJECT_REFERENCE}.make_with_object (create {PDF_INDIRECT_OBJECT}))
			l_item.add_item (create {PDF_OBJECT_REFERENCE}.make_with_object (create {PDF_INDIRECT_OBJECT}))
			assert_strings_equal ("object_references_text", object_references_text, l_item.pdf_out)
		end

--------------------------------
	object_references_text: STRING = "[
[0 0 R 0 0 R ]
]"
--------------------------------

	array_rectangles_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_ARRAY_RECTANGLES
		do
			create l_item
			l_item.add_item (create {PDF_RECTANGLE}.make ("1", "2", "3", "4"))
			l_item.add_item (create {PDF_RECTANGLE}.make ("100", "200", "300", "400"))
			assert_strings_equal ("rectangles_text", rectangles_text, l_item.pdf_out)
		end

--------------------------------
	rectangles_text: STRING = "[
[[1 2 3 4 ] [100 200 300 400 ] ]
]"
--------------------------------

	array_strings_test
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_item: PDF_ARRAY_STRINGS
		do
			create l_item
			l_item.add_item (create {PDF_STRING}.make_as_literal ("one"))
			l_item.add_item (create {PDF_STRING}.make_as_literal ("Two"))
			assert_strings_equal ("strings_text", strings_text, l_item.pdf_out)
		end

--------------------------------
	strings_text: STRING = "[
[(one) (Two) ]
]"
--------------------------------

feature {NONE} -- Implementation: In-system Refs

	pdf_array: detachable PDF_ARRAY
	pdf_array_gen: detachable PDF_ARRAY_GENERAL [PDF_OBJECT [detachable ANY]]
	pdf_array_boolean: detachable PDF_ARRAY_BOOLEANS
	pdf_array_decimal: detachable PDF_ARRAY_DECIMALS
	pdf_array_dict: detachable PDF_ARRAY_DICTIONARIES
	pdf_array_indir: detachable PDF_ARRAY_INDIRECT_OBJECTS
	pdf_array_integer: detachable PDF_ARRAY_INTEGERS
	pdf_array_key_value: detachable PDF_ARRAY_KEY_VALUES
	pdf_array_name: detachable PDF_ARRAY_NAMES
	pdf_array_object_reference: detachable PDF_ARRAY_OBJECT_REFERENCES
	pdf_array_rect: detachable PDF_ARRAY_RECTANGLES
	pdf_array_string: detachable PDF_ARRAY_STRINGS

end


