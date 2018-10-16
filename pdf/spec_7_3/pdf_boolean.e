note
	description: "Summary description for {PDF_BOOLEAN}."

class
	PDF_BOOLEAN

inherit
	PDF_OBJECT [BOOLEAN]

feature -- Settings

	set_true do value := True end
	set_false do value := False end

feature -- Output

	pdf_out: STRING
		do
			if value then
				Result := True_kw
			else
				Result := False_kw
			end
		end

note
	specification: "ISO 32000-1, section 7.3.2 Boolean Objects"
	EIS: "name=pdf_spec", "protocol=pdf", "src=C:\Users\LJR19\Documents\_Moonshot\moon_training\Training Material\Specifications\PDF\PDF32000_2008.pdf"

end
