# Fetch the Data spreadsheet from Google sheets by ID
id <- "1SxL0kpm8xXyslRKradFv03R6Sbr-YUkx09jOVW8RF8E"
google_data <- drive_get(id = id)
sheets <- sheets_get(google_data)

high_cholesterol <- read_sheet(sheets$spreadsheet_id, range="+CHOL, -Statin!A2:AL39")
myalgia <- read_sheet(sheets$spreadsheet_id, range="+Myalgi, +Statin!A2:AL20")
non_myalgia <- read_sheet(sheets$spreadsheet_id, range="-Myalgi, +Statin!A2:AL29")
control <- read_sheet(sheets$spreadsheet_id, range="Kontrol!A2:AL18")