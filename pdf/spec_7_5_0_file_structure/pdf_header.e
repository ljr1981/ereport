note
	description: "Summary description for {PDF_HEADER}."

class
	PDF_HEADER

inherit
	PDF_DOC_ELEMENT

feature -- Access

	version: STRING
		attribute
			Result := v1_4.twin
		end

	v1_0: STRING = "%%PDF-1.0"
	v1_1: STRING = "%%PDF-1.1"
	v1_2: STRING = "%%PDF-1.2"
	v1_3: STRING = "%%PDF-1.3"
	v1_4: STRING = "%%PDF-1.4"
	v1_5: STRING = "%%PDF-1.5"
	v1_6: STRING = "%%PDF-1.6"
	v1_7: STRING = "%%PDF-1.7"

feature -- Settings

	set_version (n: INTEGER)
			--
		require
			one_to_seven: (0 |..| 7).has (n)
		do
			inspect
				n
			when 0 then
				version := v1_0.twin
			when 1 then
				version := v1_1.twin
			when 2 then
				version := v1_2.twin
			when 3 then
				version := v1_3.twin
			when 4 then
				version := v1_4.twin
			when 5 then
				version := v1_5.twin
			when 6 then
				version := v1_6.twin
			when 7 then
				version := v1_7.twin
			else
				check unknown_version: False end
			end
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			Result.append_string_general (version)
			Result.append_character ('%N')
		end

invariant
	version_set: across (<<v1_0, v1_1, v1_2, v1_3, v1_4, v1_5, v1_6, v1_7>>) as ic some ic.item.same_string (version) end

;note
	main_spec: ""
	other_specs: ""
	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

end
