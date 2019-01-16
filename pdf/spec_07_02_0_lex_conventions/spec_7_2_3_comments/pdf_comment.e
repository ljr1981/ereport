note
	description: "Representation of a {PDF_COMMENT}."

class
	PDF_COMMENT

inherit
	PDF_ANY

create
	make_with_text

feature {NONE} -- Initialization

	make_with_text (a_text: STRING)
			-- `make_with_text'.
		do
			set_text (a_text)
		end

feature -- Settings

	set_text (a_text: like text)
			-- `set_text' with `a_text'.
		do
			text := a_text
		ensure
			text.same_string (a_text)
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make (text.count + 2)
			Result.append_character (Percent)
			Result.append_character (Space)
			Result.append_string_general (text)
		ensure then
			size: Result.count = text.count + 2
			prefixed: Result.substring (1, 2).same_string (Percent.out + Space.out)
			has_text: Result.has_substring (text)
		end

feature {NONE} -- Implementation: Access

	text: STRING
			-- `text' of Current.

end
