### The following PowerShell script compares the hashes of all the contents in two separate zip files. The script perform following tasks:

1. Sets the value of the variable `$WORKSPACE` to the path `C:\Users\eetch\Desktop\Hash_Script`.
2. Sets the values of the variables `$Zip_A` and `$Zip_B` to the paths of the ZIP files `Folder_A.zip` and `Folder_B.zip` respectively, located in the `$WORKSPACE` path.
3. Sets the values of the variables `$Extracted_A` and `$Extracted_B` to the paths of the folders `Folder_A` and `Folder_B` respectively, located in the `$WORKSPACE` path.
4. Extracts the contents of the ZIP files `$Zip_A` and `$Zip_B` to the folders `$Extracted_A` and `$Extracted_B` respectively, using the `Expand-Archive` cmdlet.
5. Calculates the hash of all files contained in the extracted folders `$Extracted_A` and `$Extracted_B` respectively, using the `Get-ChildItem` cmdlet and the `Get-FileHash` cmdlet, and exports the calculated hashes to CSV files named `Hashes_A.csv` and `Hashes_B.csv` respectively, located in the `$Extracted_A` and `$Extracted_B` paths respectively, using the `Export-Csv` cmdlet.
6. Sets the values of the variables `$CSV_A` and `$CSV_B` to the paths of the CSV files `Hashes_A.csv` and `Hashes_B.csv` respectively, located in the `$Extracted_A` and `$Extracted_B` paths respectively.
7. Lists the contents of the CSV files `$CSV_A` and `$CSV_B`, excluding the header row, and sorts them alphabetically, and sets the results to the variables `$Content_A` and `$Content_B` respectively, using the `Get-Content` cmdlet, `Select-Object` cmdlet with the Skip parameter, and `Sort-Object` cmdlet.
8. Compares the hash values of the files listed in `$Content_A `with those in `$Content_B`, and if the hash values match, appends the file names and the status `Verified` to the `$Final_Report` variable, using a nested `ForEach` loop and an IF statement.
9. Removes the temporary files `$CSV_A` and `$CSV_B` using the `Remove-Item` cmdlet.
10. Exports the final report contained in the `$Final_Report` variable to a CSV file named `Final_Report.csv`, located in the `$WORKSPACE path`, using the `Out-File` cmdlet.
