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
		do
			item := [create {PDF_NAME}.make (a_key), create {PDF_NAME}.make (a_value)]
		end

	make_as_obj_ref (a_key: STRING; a_obj_ref: PDF_OBJECT_REFERENCE)
			--
		do
			item := [create {PDF_NAME}.make (a_key), a_obj_ref]
		end

	make_as_integer (a_key: STRING; a_value: INTEGER)
			--
		do
			item := [create {PDF_NAME}.make (a_key), create {PDF_INTEGER}.make_with_integer (a_value)]
		end

	make_as_array (a_key: STRING; a_value: PDF_ARRAY)
		do
			item := [create {PDF_NAME}.make (a_key), a_value]
		end

	make_as_array_of_refs (a_key: STRING; a_value: PDF_ARRAY)
		do
			item := [create {PDF_NAME}.make (a_key), a_value]
		end

	make_as_dictionary (a_key: STRING; a_value: PDF_DICTIONARY_GENERAL)
		do
			item := [create {PDF_NAME}.make (a_key), a_value]
		end

feature -- Access

	key: PDF_NAME
		do
			check attached item as al_item then
				Result := al_item.key
			end
		end

	value: PDF_OBJECT [detachable ANY]
		do
			check attached item as al_item then
				Result := al_item.value
			end
		end

	value_in_value: detachable ANY
		do
			Result := value.value
		end

feature -- Settings

	set_key (a_key: STRING)
			--
		do
			check has_item: attached item as al_item then
				al_item.key.set_value (a_key)
			end
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
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
