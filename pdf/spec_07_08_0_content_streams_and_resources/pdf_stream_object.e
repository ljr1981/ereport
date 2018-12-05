note
	description: "Objects that populate a {PDF_CONTENT_STREAM}.stream"

class
	PDF_STREAM_OBJECT

inherit
	PDF_OBJECT_CONTAINER

feature {NONE} -- Implementation: Delimiters

	opening_delimiter: STRING once ("OBJECT") Result := "stream" end
	closing_delimiter: STRING once ("OBJECT") Result := "endstream" end

end
