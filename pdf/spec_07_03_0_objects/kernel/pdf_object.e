note
	description: "Abstract notion of a {PDF_OBJECT}."
	specification: "ISO 32000-1, section 7.3"

deferred class
	PDF_OBJECT [G -> detachable ANY]

inherit
	PDF_ANY

feature -- Access

	opening_delimiter: STRING
			--
		deferred
		end

	value: detachable G
			-- The `value' (if any) of Current.

	closing_delimiter: STRING
			--
		deferred
		end

	comment: detachable PDF_COMMENT
			-- A `comment' for Current (if any).

feature -- Settings

	set_value (a_value: attached like value)
			--
		do
			value := a_value
		ensure
			set: value ~ a_value
		end

	set_comment (a_comment: STRING)
			-- `set_comment' of `a_comment' into `comment'.
		do
			create comment.make_with_text (a_comment)
		ensure
			set: attached comment as al_comment
		end

feature -- Queries

	pdf_out_count: INTEGER
			-- `pdf_out_count' of Current as character count.
		do
			Result := pdf_out.count
		end

	length_hex: STRING
			-- Hex version of `pdf_out_count'.
		do
			Result := pdf_out.count.to_hex_string
		end

	string_to_hex (s: STRING): ARRAY [INTEGER]
			--
		local
			l_codes: ARRAYED_LIST [INTEGER]
		do
			create l_codes.make (s.count)
			across
				s as ic
			loop
				l_codes.force (ic.item.code)
			end
			Result := l_codes.to_array
		end

;note
	main_spec: ""
	other_specs: ""

end
