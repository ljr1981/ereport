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

	make_with_count (a_count: INTEGER)
			-- `make_with_count' of `a_count'
		do
			default_create
			count.set_value ([count.key, create {PDF_INTEGER}.make_with_integer (a_count)])
		end

feature -- Access

	dictionary: PDF_DICTIONARY_GENERAL
			-- `dictionary' for Current

	type: PDF_KEY_VALUE_NAME
			-- /Type /Outlines
		attribute
			create Result.make ("Type", "Outlines")
		end

	count: PDF_KEY_VALUE_INTEGER
			-- `count' /Count /[Int_value]
		attribute
			create Result.make ("Count", 0)
		end

;note
	main_spec: "12.3.3 Document Outline"
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
