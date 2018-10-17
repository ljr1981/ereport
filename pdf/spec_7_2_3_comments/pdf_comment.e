note
	description: "Summary description for {PDF_COMMENT}."

class
	PDF_COMMENT

inherit
	PDF_CONSTANTS
		redefine
			out
		end

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
			--
		do
			text := a_text
		ensure
			text.same_string (a_text)
		end

feature -- Output

	out: STRING
			-- <Precursor>
		do
			create Result.make (text.count + 1)
			Result.append_character (Percent)
			Result.append_string_general (text)
		end

feature {NONE} -- Implementation: Access

	text: STRING
			-- `text' of Current.

end
