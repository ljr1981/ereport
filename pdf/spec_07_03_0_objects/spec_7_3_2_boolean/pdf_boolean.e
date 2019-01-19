note
	description: "Summary description for {PDF_BOOLEAN}."
	EIS: "name=7.3.2 Boolean Objects", "protocol=URI", "src=https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/PDF32000_2008.pdf#page=22&view=FitH", "override=true"

class
	PDF_BOOLEAN

inherit
	PDF_OBJECT [BOOLEAN]
		redefine
			default_create
		end

create
	default_create,
	make_true,
	make_false

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			Precursor
			set_false
		end

	make_true
			--
		do
			set_true
		end

	make_false
			--
		do
			set_false
		end

feature -- Settings

	set_true do value := True end
	set_false do value := False end

feature -- Output

	pdf_out: STRING
		do
			create Result.make_empty
			if value then
				Result.append_string_general (True_kw)
			else
				Result.append_string_general (False_kw)
			end
			Result.adjust
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := Space.out end
	closing_delimiter: STRING once ("OBJECT") Result := Space.out end

;note
	other_specs: ""

end
