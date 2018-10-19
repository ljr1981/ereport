note
	description: "Summary description for {PDF_DOCUMENT}."

class
	PDF_DOCUMENT

inherit
	PDF_ANY
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			create header
			create body
			create trailer
		end

feature -- Access

	header: PDF_HEADER
			-- `header' of Current.
			-- Identifying the version to which Current conforms.

	body: PDF_BODY
			-- `body' of Current.
			-- Containing the objects that make up Current.

	trailer: PDF_TRAILER
			-- `trailer' of Current.
			-- Giving the location of the `xref_table' and of certain "special objects" in Current.

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			Result.append_string_general (header.pdf_out)
			Result.append_string_general (body.pdf_out)
			trailer.set_size (body.xref_table.lines.count)
			trailer.set_root (body.root)
			trailer.set_byte_offset (body.byte_offset)
			Result.append_string_general (trailer.pdf_out)
		end

;note
	main_spec: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
