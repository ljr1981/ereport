note
	description: "Summary description for {PDF_INDIRECT_OBJECT}."
	EIS: "name=7.3.10 Objects", "protocol=URI", "src=https://www.adobe.com/content/dam/acom/en/devnet/acrobat/pdfs/PDF32000_2008.pdf#page=29&view=FitH", "override=true"

class
	PDF_INDIRECT_OBJECT

inherit
	PDF_OBJECT_CONTAINER

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING = "obj"
	closing_delimiter: STRING = "endobj"

end
