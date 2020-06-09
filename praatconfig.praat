# AWT 2020-01-27
# Function to convert a comma-separated table in a file where each line is:
# Key,Value
# into a dictionary

# in: filename to read, filename of expected values table (parameter, type, required)
# out: .numbers: dictionary of parameter name -> number
#      .strings$: dictionary of parameter name -> string

procedure praatconfig: .filename$, .expected$
    # read contents of files
    Read Table from comma-separated file: .expected$
    .expectedId = selected()
    Read Table from comma-separated file: .filename$
    .tableId = selected()
    .nrows = Get number of rows
    for .row from 1 to .nrows
        selectObject: .tableId
        .paramName$ = .table$[.row,"parameter"]
        .paramValue$ = .table$[.row,"value"]
        # find parameter type in expected$
        selectObject: .expectedId
        .paramRow = Search column: "parameter", .paramName$
        if .paramRow == 0
            .paramType$ = "ignore"
        else
            .paramType$ = Get value: .paramRow, "type"
            # delete row in expected table, "checking off" this value
            Remove row: .paramRow
        endif
        if .paramType$ == "ignore"
            writeInfoLine: "Warning: parameter ", .paramName$, " was not expected and will be ignored in ", .filename$
        elsif .paramType$ == "number"
            val = number(.paramValue$)
            if val == undefined
                exitScript: "Parameter ", .paramName$, " cannot be interpreted as a number in ", .filename$
            endif
            .numbers[.paramName$] = val
        elsif .paramType$ == "string"
            # is it useful to say that values given for numbers and strings are disjoint?
            # i.e. nothing that can be interpreted as a number will be stored as a string?
            # assume not for now
            # val = number(.paramValue$)
            # if val <> undefined
            #    exitScript: "Parameter ", .paramName$, " can be interpreted as a number, should be a string."
            # endif
            .strings$[.paramName$] = .paramValue$
        else
            writeInfoLine: "Warning: parameter ", .paramName$, " has unexpected type ", .paramType$, " and will not be checked in ", .filename$
        endif
    endfor
    # All done, now check table for remaining required rows
    nowarn Extract rows where column (text): "required", "is equal to", "true"
    .requiredId = selected()
    .requiredNrows = Get number of rows
    if .requiredNrows <> 0
        for .rowNumber from 1 to .requiredNrows
            writeInfoLine: "Parameter ", .paramName$, " is required, but it was not found in ", .filename$
        endfor
        exitScript: .requiredNrows, " required paramters not found in ", .filename$, ", exiting."
    endif
    # delete extracted table
    selectObject: .requiredId
    Remove
    # delete expected table
    selectObject: .expectedId
    Remove
endproc
