note
	description: "Summary description for {PDF_OUTLINES_DICTIONARY}."

class
	PDF_OUTLINES_DICTIONARY

inherit
	PDF_INDIRECT_OBJECT

create
	make,
	make_with_count

feature {NONE} -- Initialization

	make
			--
		do
			make_with_count (0)
		end

	make_with_count (a_value: INTEGER)
			--
		do
			default_create
			create dictionary
			create type.make_as_name ("Type", "Outlines")
			dictionary.add_object (type)
			create count.make_as_integer ("Count", a_value)
			dictionary.add_object (count)
			add_object (dictionary)
		end

feature -- Access

	dictionary: PDF_DICTIONARY

	type: PDF_KEY_VALUE

	count: PDF_KEY_VALUE

end
