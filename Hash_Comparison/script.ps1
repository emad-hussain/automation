#Assigning Variables
$WORKSPACE = "C:\Users\eetch\Desktop\Hash_Script"

$Zip_A = "$WORKSPACE\Folder_A.zip"
$Zip_B = "$WORKSPACE\Folder_B.zip"

$Extracted_A = "$WORKSPACE\Folder_A"
$Extracted_B = "$WORKSPACE\Folder_B"

#Extracting .zip files
Expand-Archive -Path $Zip_A -DestinationPath $Extracted_A
Expand-Archive -Path $Zip_B -DestinationPath $Extracted_B

#Calculating hash of all files contained in extracted folders
Get-ChildItem -Path $Extracted_A -File | Get-FileHash | Export-Csv -Path "$Extracted_A\Hashes_A.csv" -NoTypeInformation
Get-ChildItem -Path $Extracted_B -File | Get-FileHash | Export-Csv -Path "$Extracted_B\Hashes_B.csv" -NoTypeInformation

#Exporting calculated hashes to CSV format
$CSV_A = "$Extracted_A\Hashes_A.csv" 
$CSV_B = "$Extracted_B\Hashes_B.csv"

#Listing contents of exported CSV's
$Content_A = Get-Content $CSV_A | Select-Object -Skip 1 | Sort-Object
$Content_B = Get-Content $CSV_B | Select-Object -Skip 1 | Sort-Object

#Comparing Hashes
$Final_Report = "Files_In_Zip_A,Files_In_Zip_B,Hash_Status"

ForEach ($a in $Content_A)
{
    $File_A= ($a -split ",")[2]
    $Hash_A = ($a -split ",")[1]

    ForEach ($b in $Content_B)

        {

        $File_B= ($b -split ",")[2]
        $Hash_B = ($b -split ",")[1]

        IF ($Hash_A -eq $Hash_B)
        {
            $Final_Report += "`n$File_A,$File_B,Verified"

        }

     }
}

#Removing temporary files
Remove-Item -Path $CSV_A
Remove-Item -Path $CSV_B

#Exporting Final Results into CSV format
$Final_Report | Out-File -FilePath "$WORKSPACE\Final_Report.csv" -Encoding UTF8 -NoClobber