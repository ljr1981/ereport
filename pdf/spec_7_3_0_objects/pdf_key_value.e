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
	make_as_obj_ref

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

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := left_parenthesis.out end
	closing_delimiter: STRING once ("OBJECT") Result := right_parenthesis.out end

;end
