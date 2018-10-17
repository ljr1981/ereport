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
			create xref_table
			create trailer
		end

feature -- Access

	header: PDF_HEADER
			-- `header' of Current.
			-- Identifying the version to which Current conforms.

	body: PDF_BODY
			-- `body' of Current.
			-- Containing the objects that make up Current.

	xref_table: PDF_XREF_TABLE
			-- `xref_table' of Current.
			-- Information about what indirect objects are in Current.

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
			Result.append_string_general (xref_table.pdf_out)
			Result.append_string_general (trailer.pdf_out)
		end

end
