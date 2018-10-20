note
	description: "Summary description for {PDF_KEY_VALUE_DICTIONARY}."

class
	PDF_KEY_VALUE_DICTIONARY

inherit
	PDF_KEY_VALUE

create
	make

feature {NONE} -- Initialization

	make (a_key: STRING; a_dict: PDF_DICTIONARY_GENERAL)
			--
		do
			make_as_dictionary (a_key, a_dict)
		end

end
