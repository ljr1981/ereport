note
	description: "Representation of {PDF_KEY_VALUE_INTEGER}."

class
	PDF_KEY_VALUE_INTEGER

inherit
	PDF_KEY_VALUE

create
	make

feature {NONE} -- Initialization

	make (a_key: STRING; a_value: INTEGER)
			-- `make' Current with "/Key" (`a_key') and "/Value" (`a_value').
		do
			make_as_integer (a_key, a_value)
		end

end
