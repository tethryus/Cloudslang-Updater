Set-ExecutionPolicy Unrestricted

#First run only. Creating necessary files and folders if needed.
$baseDir = "$env:USERPROFILE\cloudslang"

If (!(Test-Path $baseDir)) {
   New-Item -Path $baseDir -ItemType Directory
}
else {
   Write-Host "Your base directory $baseDir already exists!"
}

If (!(Test-Path $baseDir\version)) {
   New-Item -Path $baseDir -ItemType File
}
else {
   Write-Host "Your version file already exists!"
}

sleep 5

$releaseParams = @{
    Uri = "https://api.github.com/repos/CloudSlang/cloud-slang/releases";
    Method = 'GET';
    Headers = @{Accept = 'application/json'};
    ContentType = 'application/json';
    Body = (ConvertTo-Json $releaseData -Compress)
}

$result = Invoke-RestMethod @releaseParams

$tag = $result.tag_name[0]

$destDir = "$env:USERPROFILE\cloudslang\$tag"

If (!(Test-Path $destDir)) {
   New-Item -Path $destDir -ItemType Directory
}
else {
   Write-Host "Directory already exists!"
}
Push-Location $destDir

#CheckCSrelease function. Checks whether you have the latest Release agains a version file.
function checkRelease {
$version =  Get-Content "$baseDir\version"
foreach ($ver in $version){
If ($version -Match $tag) {
	Write-Host "Release $tag already exists"}
else {
	Write-Host "New release $tag Found. Correct any shortcuts you might have."
    "$tag" | Out-File -Encoding Ascii -Append $baseDir\version
	 }
                          }
 sleep 5
 mainmenu 
                      }

#CslangUpdate function. Updates to the CS version given by the $tag var, if you choose to.
function cslangUpdate {
foreach ($num in 0,4){
$asset = $result.assets[$num].url
$ZipFile = $result.assets[$num].name

$releaseAssetParams = @{
    Uri = $asset;
    Method = 'GET';
    Headers = @{Accept = 'application/octet-stream'};
    ContentType = 'application/octet-stream';
					   }

Invoke-RestMethod @releaseAssetParams -OutFile $ZipFile
					}
 sleep 5
 mainmenu 
						}
						
#Areyousure function. Alows user to select y or n when asked to exit. Y exits and N returns to main menu.  
 function areyousure {$areyousure = read-host "Are you sure you want to exit? (y/n)"  
           if ($areyousure -eq "y"){exit}  
           if ($areyousure -eq "n"){mainmenu}  
           else {write-host -foregroundcolor red "Invalid Selection"   
                 areyousure  
                }  
                     }  					
					 
 #Mainmenu function. Contains the screen output for the menu and waits for and handles user input.  
 function mainmenu{  
 cls  
 echo "-----------------Cloudslang Updater----------------------"  
 echo ""  
 echo ""  
 echo "    1. Check for Update"  
 echo "    2. Backup existing CS version - will implement later?"  
 echo "    3. Update CS version"  
 echo "    4. Exit"  
 echo ""  
 echo ""
 echo "     WARNING: If you choose to update and have any"
 echo "              shortcuts created, please set the right"
 echo "              paths if needed. POC - testing"
 echo "---------------------------------------------------------"  
 $answer = read-host "Please Make a Selection"  
 if ($answer -eq 1){checkRelease}  
 if ($answer -eq 2){calc}  
 if ($answer -eq 3){cslangUpdate}  
 if ($answer -eq 4){areyousure}  
 else {write-host -ForegroundColor red "Invalid Selection"  
       sleep 5  
       mainmenu  
      }  
                }  
 mainmenu  
