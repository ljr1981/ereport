note
	description: "Representation of {PDF_KEY_VALUE_NAME}."

class
	PDF_KEY_VALUE_NAME

inherit
	PDF_KEY_VALUE

create
	make

feature {NONE} -- Initialization

	make (a_key, a_value: STRING)
			-- `make' Current with "/Key" (`a_key') and "/Value" (`a_value').
		do
			make_as_name (a_key, a_value)
		end

end
