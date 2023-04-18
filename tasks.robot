*** Settings ***
Documentation       Orders robots from RobotSpareBin Industries Inc.
...                 Saves the order HTML receipt as a PDF file.
...                 Saves the screenshot of the ordered robot.
...                 Embeds the screenshot of the robot to the PDF receipt.
...                 Creates ZIP archive of the receipts and the images.
...

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.HTTP
Library             RPA.Tables
Library             RPA.PDF
Library             RPA.Archive


*** Tasks ***
Order robots from RobotSpareBin Industries Inc.
    Open the intranet website
    Fill out form for each order
    Create Zip File Of All Receipts
    [Teardown]    Close Browser


*** Keywords ***
Open the intranet website
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order

Close annoying popup
    Wait Until Page Contains Element    class:modal
    Click Button    OK

Fill out form for each order
    ${order_list} =    Get orders
    FOR    ${order}    IN    @{order_list}
        Close annoying popup
        Enter Form Data    ${order}
        Click Button    Preview
        Take Screenshot Of Robot    ${order}[Order number]
        Wait Until Keyword Succeeds    1 min    1 sec    Place Order
        Get Receipt    ${order}[Order number]
        Wait Until Page Contains Element    id:order-another
        Click Button    Order another robot
    END

Create Zip File Of All Receipts
    Archive Folder With Zip    ${OUTPUT_DIR}${/}PDFS    ${OUTPUT_DIR}${/}reciepts.zip

Place Order
    Click Button    Order
    Assert Order Success

Take Screenshot Of Robot
    [Arguments]    ${order_num}
    Screenshot    css:div#robot-preview-image    ${OUTPUT_DIR}${/}${order_num}_robot_preview.png

Get Receipt
    [Arguments]    ${order_num}
    Wait Until Element Is Visible    id:receipt
    ${receipt_html} =    Get Element Attribute    id:receipt    outerHTML
    Html To Pdf    ${receipt_html}    ${OUTPUT_DIR}${/}PDFS${/}${order_num}_OrderPDF.pdf
    Add Watermark Image To Pdf
    ...    ${OUTPUT_DIR}${/}${order_num}_robot_preview.png
    ...    ${OUTPUT_DIR}${/}PDFS${/}${order_num}_OrderPDF.pdf
    ...    ${OUTPUT_DIR}${/}PDFS${/}${order_num}_OrderPDF.pdf

Enter Form Data
    [Arguments]    ${order}
    Select From List By Value    head    ${order}[Head]
    Select Radio Button    body    ${order}[Body]
    Input Text    //input[@type="number"]    ${order}[Legs]
    Input Text    address    ${order}[Address]
    Click Button    Preview

Download the Orders file
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=True

Get orders
    Download the Orders file
    ${orders} =    Read table from CSV    orders.csv    header=True
    RETURN    ${orders}

Assert Order Success
    Wait Until Page Contains Element    id:receipt
    Location Should Be    https://robotsparebinindustries.com/#/robot-order
