note
	description: "Summary description for {PDF_OBJECT_REFERENCE}."
	EIS: "name=7.3 Objects", "protocol=URI", "src=https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/PDF32000_2008.pdf#page=21&view=FitH", "override=true"

class
	PDF_OBJECT_REFERENCE

inherit
	PDF_OBJECT [detachable ANY]
		redefine
			set_parent_ref,
			pdf_out
		end

create
	make_with_object

feature {NONE} -- Initialization

	make_with_object (obj: like object)
			--
		do
			object := obj
		end

feature -- Access

	object: PDF_OBJECT [detachable ANY]

feature -- Settings

	set_parent_ref (a_ref: attached like parent_ref)
			--
		do
			object.set_parent_ref (a_ref)
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			Result.append_string_general (object.object_number.out)
			Result.append_character (' ')
			Result.append_string_general (object.generation_number.out)
			Result.append_character (' ')
			Result.append_string_general ("R")
			Result.adjust
		end

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := "" end
	closing_delimiter: STRING once ("OBJECT") Result := "" end

;note
	main_spec: ""
	other_specs: ""

end
