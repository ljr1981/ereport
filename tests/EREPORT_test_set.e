note
	description: "Tests of {EREPORT}."
	testing: "type/manual"

class
	EREPORT_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		redefine
			on_prepare
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

	FW_PROCESS_HELPER
		undefine
			default_create
		end

feature {NONE} -- Initialization

	on_prepare
			-- <Precursor>
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (".\tests\assets\invoice.html")
			l_file.put_string (invoice_html)
			l_file.close

			create l_file.make_create_read_write (".\tests\assets\data.json")
			l_file.put_string (data_json)
			l_file.close
		end

feature -- Test routines

	ereport_tests
			-- `ereport_tests'
		local
			l_result: STRING
		do
			l_result := output_of_command (jsreport_cmd, jsreport_directory)
			assert_32 ("rendering_success", l_result.has_substring ("rendering has finished successfully and saved in: "))
		end

feature {NONE} -- Implementation: Test Support

	jsreport_cmd: STRING = "[
.\jsreport\jsreport.exe render --template.engine=handlebars --template.recipe=chrome-pdf --template.content="..\tests\assets\invoice.html" --data="..\tests\assets\data.json" --out="out.pdf"
]"

	jsreport_directory: STRING = ".\jsreport"

	jsreport_cli_result: STRING = "[

]"

	invoice_html: STRING = "[
<!-- 
Invoice dynamically rendered into html using handlebars and converted into pdf
using chrome-pdf recipe. The styles are extracted into separate asset for 
better readability and later reuse.

Data to this sample are mocked at the design time and should be filled on the 
incoming API request.
!-->

<html>
    <head>
        <meta content="text/html" http-equiv="Content-Type">
        <style>
			.invoice-box {
			    max-width: 800px;
			    margin: auto;
			    padding: 30px;
			    border: 1px solid #eee;
			    box-shadow: 0 0 10px rgba(0, 0, 0, .15);
			    font-size: 16px;
			    line-height: 24px;
			    font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
			    color: #555;
			}
			.invoice-box table {
			    width: 100%;
			    line-height: inherit;
			    text-align: left;
			}
			.invoice-box table td {
			    padding: 5px;
			    vertical-align: top;
			}
			.invoice-box table tr td:nth-child(2) {
			    text-align: right;
			}
			.invoice-box table tr.top table td {
			    padding-bottom: 20px;
			}
			.invoice-box table tr.top table td.title {
			    font-size: 45px;
			    line-height: 45px;
			    color: #333;
			}
			.invoice-box table tr.information table td {
			    padding-bottom: 40px;
			}
			.invoice-box table tr.heading td {
			    background: #eee;
			    border-bottom: 1px solid #ddd;
			    font-weight: bold;
			}
			.invoice-box table tr.details td {
			    padding-bottom: 20px;
			}
			.invoice-box table tr.item td {
			    border-bottom: 1px solid #eee;
			}
			.invoice-box table tr.item.last td {
			    border-bottom: none;
			}
			.invoice-box table tr.total td:nth-child(2) {
			    border-top: 2px solid #eee;
			    font-weight: bold;
			}
			@media only screen and (max-width: 600px) {
			    .invoice-box table tr.top table td {
			        width: 100%;
			        display: block;
			        text-align: center;
			    }
			    .invoice-box table tr.information table td {
			        width: 100%;
			        display: block;
			        text-align: center;
			    }
			}
        </style>
    </head>
    <body>
        <div class="invoice-box">
            <table cellpadding="0" cellspacing="0">
                <tr class="top">
                    <td colspan="2">
                        <table>
                            <tr>
                                <td class="title">
                                    <img src="C:\Users\LJR19\Documents\GitHub\ereport\tests\assets\logo.png" style="width:100%; max-width:300px;" />
                                </td>
                                <td>
                                    Invoice #: {{number}}
                                    <br> Created: {{creation_date}}
                                    <br> Due: {{net_20_date}}
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="information ">
                    <td colspan="2 ">
                        <table>
                            <tr>
                                <td>
                                    {{seller.name}}<br>
                                    {{seller.road}}<br>
                                    {{seller.country}}
                                </td>
                                <td>
                                    {{buyer.name}}<br>
                                    {{buyer.road}}<br>
                                    {{buyer.country}}
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="heading ">
                    <td>
                        Item
                    </td>
                    <td>
                        Price
                    </td>
                </tr>
                {{#each items}}
                <tr class="item">
                    <td>
                        {{name}}
                    </td>
                    <td>
                        $ {{price}}
                    </td>
                </tr>
                {{/each}}
                <tr class="total ">
                    <td></td>
                    <td>
                        Total: ${{item_total}}
                    </td>
                </tr>
		        Page&nbsp;<span class="pageNumber"></span>&nbsp;of&nbsp;<span class="totalPages"></span>
            </table>
        </div>
    </body>
</html>
]"

	data_json: STRING = "[
{
    "number": "123",
    "creation_date": "10/01/2018",
    "net_20_date": "10/21/2018",
    "seller": {
        "name": "Next Step Webs, Inc.",
        "road": "12345 Sunny Road",
        "country": "Sunnyville, TX 12345"
    },
    "buyer": {
        "name": "Acme Corp.",
        "road": "16 Johnson Road",
        "country": "Paris, France 8060"
    },
    "items": [
    	{"name": "Website design", "price": "300.00"},
    	{"name": "Widget #1", "price": "100.00"},
    	{"name": "Widget #2", "price": "200.00"},
    	{"name": "Widget #3", "price": "300.00"},
    	{"name": "Widget #4", "price": "400.00"},
    	{"name": "Widget #5", "price": "500.00"},
    	{"name": "Widget #6", "price": "600.00"},
    	{"name": "Widget #7", "price": "700.00"},
    	{"name": "Widget #8", "price": "800.00"},
    	{"name": "Widget #9", "price": "900.00"},
    	{"name": "Service #1", "price": "100.00"},
    	{"name": "Service #2", "price": "200.00"},
    	{"name": "Service #3", "price": "300.00"},
    	{"name": "Service #4", "price": "400.00"},
    	{"name": "Service #5", "price": "500.00"},
    	{"name": "Service #6", "price": "600.00"},
    	{"name": "Service #7", "price": "700.00"},
    	{"name": "Service #8", "price": "800.00"},
    	{"name": "Service #9", "price": "900.00"},
    	{"name": "Other #1", "price": "100.00"},
    	{"name": "Other #2", "price": "200.00"},
    	{"name": "Other #3", "price": "300.00"},
    	{"name": "Other #4", "price": "400.00"},
    	{"name": "Other #5", "price": "500.00"},
    	{"name": "Other #6", "price": "600.00"},
    	{"name": "Other #7", "price": "700.00"},
    	{"name": "Other #8", "price": "800.00"},
    	{"name": "Other #9", "price": "900.00"}
    	],
    "item_total": "13,800.00"
}
]"

end
