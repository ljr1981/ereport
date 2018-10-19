note
	description: "Summary description for {PDF_FONT}."
	example: "[
4 0 obj
<</Type /Font
/Subtype /Type1
/Name /F1
/BaseFont /Helvetica
/Encoding /MacRomanEncoding
>>
endobj
]"

class
	PDF_FONT

inherit
	PDF_INDIRECT_OBJECT

create
	make,
	make_with_font_info

feature {NONE} -- Initialization

	make (a_name: STRING)
			-- `make' with `a_name' /Name /Value key-value.
		do
			default_create

			create dictionary
			dictionary.add_object (type)
			add_object (dictionary)

			create name.make_as_name ("Name", a_name)
			dictionary.add_object (name)
		end

	make_with_font_info (a_name: STRING; a_subtype, a_base_font, a_encoding: STRING)
			-- `make_with_font_info' through `make', with added font-info.
		do
			make (a_name)
			dictionary.add_object (create {PDF_KEY_VALUE}.make_as_name ("Subtype", a_subtype))
			dictionary.add_object (create {PDF_KEY_VALUE}.make_as_name ("BaseFont", a_base_font))
			dictionary.add_object (create {PDF_KEY_VALUE}.make_as_name ("Encoding", a_encoding))
		end

feature -- Access

	name: PDF_KEY_VALUE
			-- /Name /[Value]

feature {NONE} -- Implementation: Access

	type: PDF_KEY_VALUE
			-- /Type /Font
		attribute
			create Result.make_as_name ("Type", "Font")
		end

	dictionary: PDF_DICTIONARY_GENERAL

feature -- Queries

	name_value: STRING
			-- Value of `name' (/Name /[Value]).
		do
			check has_name: attached {STRING} name.value_in_value as al_text then
				Result := al_text
			end
		end

		-- pt / 0.75 = px
		--
		--6pt		8px		0.5em	50%			Sample
		--7pt		9px		0.55em	55%			Sample
		--7.5pt		10px	0.625em	62.5%		x-small	Sample
		--8pt		11px	0.7em	70%			Sample
		--9pt		12px	0.75em	75%			Sample
		--10pt		13px	0.8em	80%			small	Sample
		--10.5pt	14px	0.875em	87.5%		Sample
		--11pt		15px	0.95em	95%			Sample
		--12pt		16px	1em		100%		medium	Sample
		--13pt		17px	1.05em	105%		Sample
		--13.5pt	18px	1.125em	112.5%		large	Sample
		--14pt		19px	1.2em	120%		Sample
		--14.5pt	20px	1.25em	125%		Sample
		--15pt		21px	1.3em	130%		Sample
		--16pt		22px	1.4em	140%		Sample
		--17pt		23px	1.45em	145%		Sample
		--18pt		24px	1.5em	150%		x-large	Sample
		--20pt		26px	1.6em	160%		Sample
		--22pt		29px	1.8em	180%		Sample
		--24pt		32px	2em		200%		xx-large	Sample
		--26pt		35px	2.2em	220%		Sample
		--27pt		36px	2.25em	225%		Sample
		--28pt		37px	2.3em	230%		Sample
		--29pt		38px	2.35em	235%		Sample
		--30pt		40px	2.45em	245%		Sample
		--32pt		42px	2.55em	255%		Sample
		--34pt		45px	2.75em	275%		Sample
		--36pt		48px	3em		300%		Sample

;note
	main_spec: "9.6.0 Simple Fonts"
	other_specs: "9.2 Organization and Use of Fonts"
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
