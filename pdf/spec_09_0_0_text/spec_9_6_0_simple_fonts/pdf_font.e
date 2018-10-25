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
		require
			a_name_not_empty: not a_name.is_empty
		do
			default_create

			create dictionary
			dictionary.add_object (type)
			add_object (dictionary)

			create name.make_as_name (Name_key_kw, a_name)
			dictionary.add_object (name)
		end

	make_with_font_info (a_name, a_subtype, a_base_font, a_encoding: STRING)
			-- `make_with_font_info' through `make', with added font-info.
		require
			a_name_not_empty: not a_name.is_empty
			a_subtype_not_empty: not a_subtype.is_empty
			a_base_font_not_empty: not a_base_font.is_empty
			a_encoding_not_empty: not a_encoding.is_empty
		do
			make (a_name)
			create subtype.make_as_name (Subtype_key_kw, a_subtype); dictionary.add_object (subtype)
			create basefont.make_as_name (BaseFont_key_kw, a_base_font); dictionary.add_object (basefont)
			create encoding.make_as_name (Encoding_key_kw, a_encoding); dictionary.add_object (encoding)
		end

feature -- Access

	name: PDF_KEY_VALUE
			-- /Name /[Value]

feature {NONE} -- Implementation: Access

	type: PDF_KEY_VALUE
			-- /Type /Font
		attribute
			create Result.make_as_name (Type_key_kw, "Font")
		end

	subtype: PDF_KEY_VALUE
			-- /Subtype /[Value]
		attribute
			create Result.make_as_name (Subtype_key_kw, "TrueType")
		end

	basefont: PDF_KEY_VALUE
			-- /BaseFont /[Value]
		attribute
			create Result.make_as_name (BaseFont_key_kw, "CourierNew")
		end

	encoding: PDF_KEY_VALUE
			-- /Encoding /[Value]
		attribute
			create Result.make_as_name (Encoding_key_kw, "StandardEncoding")
		end

	dictionary: PDF_DICTIONARY_GENERAL

feature -- Queries

	name_value: STRING
			-- Value of `name' (/Name /[Value])
		do
			check
				attached {like name_value} name.value_in_value as al_value and then
					not al_value.is_empty
			then
				Result := al_value
			end
		end

	type_value: STRING
			-- Value of `name' (/Type /[Value])
		do
			check
				attached {like type_value} type.value_in_value as al_value and then
					not al_value.is_empty
			then
				Result := al_value
			end
		end

	basefont_value: STRING
			-- Value of `name' (/BaseFont /[Value])
		do
			check attached {like basefont_value} type.value_in_value as al_value and then
					not al_value.is_empty
			then
				Result := al_value
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

feature -- Constants: Keywords

	Name_key_kw: STRING = "Name"
	Type_key_kw: STRING = "Type"
	Subtype_key_kw: STRING = "Subtype"
	BaseFont_key_kw: STRING = "Basefont"
	Encoding_key_kw: STRING = "Encoding"

invariant
	name_type: attached name.key.text as al_name and then al_name.same_string (Name_key_kw) attached {PDF_NAME} name.value
	name_type: attached Type.key.text as al_type and then al_type.same_string (Type_key_kw) attached {PDF_NAME} Type.value
	name_type: attached Subtype.key.text as al_subtype and then al_subtype.same_string (Subtype_key_kw) attached {PDF_NAME} Subtype.value
	name_type: attached BaseFont.key.text as al_basefont and then al_basefont.same_string (BaseFont_key_kw) attached {PDF_NAME} BaseFont.value
	name_type: attached Encoding.key.text as al_encoding and then al_encoding.same_string (Encoding_key_kw) attached {PDF_NAME} Encoding.value

	type_type: attached {PDF_NAME} type.value
	subtype_type: attached {PDF_NAME} subtype.value
	basefont_type: attached {PDF_NAME} basefont.value
	encoding_type: attached {PDF_NAME} encoding.value

;note
	main_spec: "9.6.0 Simple Fonts"
	other_specs: "9.2 Organization and Use of Fonts"
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
