note
	description: "Summary description for {PDF_OUTLINES}."

class
	PDF_OUTLINES

inherit
	PDF_INDIRECT_OBJECT
		redefine
			default_create
		end

create
	default_create,
	make_with_count

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			Precursor
			create dictionary
			dictionary.add_object (type)
			dictionary.add_object (count)
			add_object (dictionary)
		end

	make_with_count (a_value: INTEGER)
			--
		do
			default_create
			count.set_value ([count.key, create {PDF_INTEGER}.make_with_integer (a_value)])
		end

feature -- Access

	dictionary: PDF_DICTIONARY

	type: PDF_KEY_VALUE
			--
		attribute
			create Result.make_as_name ("Type", "Outlines")
		end

	count: PDF_KEY_VALUE
			--
		attribute
			create Result.make_as_integer ("Count", 0)
		end

end
