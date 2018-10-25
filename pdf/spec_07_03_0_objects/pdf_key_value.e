note
	description: "Summary description for {PDF_KEY_VALUE}."

class
	PDF_KEY_VALUE

inherit
	PDF_OBJECT [TUPLE [key: PDF_NAME; value: PDF_OBJECT [detachable ANY]]]
		rename
			value as item
		end

create
	default_create,
	make_as_name,
	make_as_obj_ref,
	make_as_integer,
	make_as_array,
	make_as_array_of_refs,
	make_as_dictionary

feature {NONE} -- Initialization

	make_as_name (a_key, a_value: STRING)
			--
		require
			a_key_not_emty: not a_key.is_empty
		do
			item := [create {PDF_NAME}.make (a_key), create {PDF_NAME}.make (a_value)]
		ensure
			attached item as al_item and then
				attached {like a_value} al_item.value.value as al_value and then al_value.same_string (a_value)
			name_set: attached {like a_key} al_item.key.text as al_text and then al_text.same_string (a_key)
		end

	make_as_obj_ref (a_key: STRING; a_obj_ref: PDF_OBJECT_REFERENCE)
			--
		require
			a_key_not_emty: not a_key.is_empty
		do
			item := [create {PDF_NAME}.make (a_key), a_obj_ref]
		ensure
			item_set: attached item as al_item
			name_set: attached {like a_key} al_item.key.text as al_value and then al_value.same_string (a_key)
		end

	make_as_integer (a_key: STRING; a_value: INTEGER)
			--
		require
			a_key_not_emty: not a_key.is_empty
		do
			item := [create {PDF_NAME}.make (a_key), create {PDF_INTEGER}.make_with_integer (a_value)]
		ensure
			item_set: attached item as al_item
			name_set: attached {like a_key} al_item.key.text as al_value and then al_value.same_string (a_key)
		end

	make_as_array (a_key: STRING; a_value: PDF_ARRAY)
			--
		require
			a_key_not_emty: not a_key.is_empty
		do
			item := [create {PDF_NAME}.make (a_key), a_value]
		ensure
			item_set: attached item as al_item
			name_set: attached {like a_key} al_item.key.text as al_value and then al_value.same_string (a_key)
		end

	make_as_array_of_refs (a_key: STRING; a_value: PDF_ARRAY)
			--
		require
			a_key_not_emty: not a_key.is_empty
		do
			item := [create {PDF_NAME}.make (a_key), a_value]
		ensure
			item_set: attached item as al_item
			name_set: attached {like a_key} al_item.key.text as al_value and then al_value.same_string (a_key)
		end

	make_as_dictionary (a_key: STRING; a_value: PDF_DICTIONARY_GENERAL)
			--
		require
			a_key_not_emty: not a_key.is_empty
		do
			item := [create {PDF_NAME}.make (a_key), a_value]
		ensure
			item_set: attached item as al_item
			name_set: attached {like a_key} al_item.key.text as al_value and then al_value.same_string (a_key)
		end

feature -- Access

	key: PDF_NAME
			-- `key' of Current
		require
			has_item: attached item
		do
			check attached item as al_item then
				Result := al_item.key
			end
		end

	value: PDF_OBJECT [detachable ANY]
			-- `value' of Current
		require
			has_item: attached item
		do
			check attached item as al_item then
				Result := al_item.value
			end
		end

	value_in_value: detachable ANY
			-- `value_in_value' of Current
		require
			has_item: attached item
		do
			Result := value.value
		ensure
			has_result: attached Result as al_result implies al_result ~ value.value
		end

feature -- Settings

	set_key (a_key: STRING)
			--
		require
			has_item: attached item as al_item
		do
			check has_item: attached item as al_item then
				al_item.key.set_value (a_key)
			end
		ensure
			key_set: attached key as al_key and then
						attached al_key.text as al_text and then
						al_text.same_string (a_key)
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			check has_item: attached item as al_item end
			check has_key: attached key as al_key end
			create Result.make_empty
			Result.append_string_general (key.pdf_out)
			Result.append_character (' ')
			Result.append_string_general (value.pdf_out)
			Result.adjust
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := left_parenthesis.out end
	closing_delimiter: STRING once ("OBJECT") Result := right_parenthesis.out end

;note
	main_spec: ""
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
