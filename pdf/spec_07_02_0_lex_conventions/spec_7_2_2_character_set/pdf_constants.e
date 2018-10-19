note
	description: "Representation of {PDF_CONSTANTS}."

class
	PDF_CONSTANTS

feature {NONE} -- Implementation: Keywords

	True_kw: STRING = "true"
			-- Keyword "true"

	False_kw: STRING = "false"
			-- Keyword "false"

	Obj_kw: STRING = "obj"
			-- Keyword "obj" (object)

feature {NONE} -- Implementation: Whitespace Characters

	Null: CHARACTER once create Result end
			-- `Null' character constant.

	Horizontal_tab, htab, ht: CHARACTER once Result := '%T' end
			-- `Horizontal_tab' character constant.

	Line_feed, lf: CHARACTER once Result := '%N' end
			-- `Line_feed' character constant.

	Form_feed, ff: CHARACTER once Result := '%F' end
			-- `Form_feed' character constant.

	Carriage_return, cr, Newline: CHARACTER once Result := '%R' end
			-- `Carriage_return' character constant.

	Eol: STRING once create Result.make_empty; Result.append_character (Newline); Result.append_character (Line_feed) end
			-- `Eol' or end-of-line is `Carriage_return' or `Newline', followed by a `Line_feed'.

	Space, Spc, Sp: CHARACTER once Result := ' ' end
			-- `Space' character constant.

	Backspace, bspc, bs: CHARACTER once Result := '%B' end
			-- `Backspace' character constant.

feature {NONE} -- Implementation: Delimiter Characters

	left_parenthesis, lcurly, lparen: CHARACTER once Result := '(' end
			-- Left Parenthesis or "(".

	right_parenthesis, rcurly, rparen: CHARACTER once Result := ')' end
			-- Right Parenthesis or ")".

	less_than, lessthan, lt: CHARACTER once Result := '<' end
			-- Less-than symbol, or "<".

	greater_than, greaterthan, gt: CHARACTER once Result := '>' end
			-- Greater-than symbol, or ">".

	left_square_bracket, lbracket: CHARACTER once Result := '[' end
			-- Left Square Bracket, or "[".

	right_square_bracket, rbracket: CHARACTER once Result := ']' end
			-- Right Square Bracket, or "]".

	left_curly_bracket, opening_brace: CHARACTER once Result := '{' end
			-- Left Curly Bracket or Opening Brace, or "{".

	right_curly_bracket, closing_brace: CHARACTER once Result := '}' end
			-- Right Curly Bracket or Closing Brace, or "}".

	solidus, slash: CHARACTER once Result := '/' end
			-- Solidus or Slash, or "/". (not back-slash, but forward)

	Reverse_solidus, backslash: CHARACTER once create Result; Result.code.set_item ({ASCII}.Backslash) end
			-- Backslash

	percent: CHARACTER once create Result; Result.code.set_item ({ASCII}.percent) end
			-- Percent, or "%".

end