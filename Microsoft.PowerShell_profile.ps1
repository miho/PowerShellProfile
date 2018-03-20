echo "Profile loaded from $profile"
cd /Users/miho/Documents/
 
# Set environment variables
#$env:MAVEN_OPTS = "-Xmx512m"
#$env:MAVEN_VERSION = "3.3.9"
$env:JAVA_HOME = "C:\Program Files\Java\jdk-9"
#$env:M2_HOME = "C:\apache-maven-$($env:MAVEN_VERSION)"
$env:PATH = "$($env:M2_HOME)\bin;$($env:JAVA_HOME)\bin;$($env:PATH)"
 
echo "Java home is $($env:JAVA_HOME)"
#echo "Maven home is $($env:M2_HOME)"

# du -sh for powershell

# https://it.awroblew.biz/powershell-du-sh-script/
Function du
{
	param (
	[Parameter(Mandatory=$true)]
	[string]$dir
	)
	write-host "Working...... "
	get-childitem $dir |
	foreach-object {
	$f=$_
	get-ChildItem -Recurse $_.FullName | measure-object -property length -sum | select @{Name="Name"; Expression={$f}} , @{Name="Sum (MB)"; Expression={ "{0:N3}" -f ($_.sum / 1MB) }}, Sum
	} | sort Sum -desc | format-table -Property Name,"Sum (MB)", Sum -autosize
}

Function dev64 {
# http://evandontje.com/2013/06/06/emulate-the-visual-studio-command-prompt-in-powershell/
# Move to the directory where vcvarsall.bat/VsDevCmd.bat is stored
#pushd "$env:VS140COMNTOOLS\..\..\VC"
pushd "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools"
# Call the .bat file to set the variables in a temporary cmd session and use 'set' to read out all session variables and pipe them into a foreach to iterate over each variable
cmd /c "VsDevCmd.bat -arch=x64 & set" | foreach {
  # if the line is a session variable
  if( $_ -match "=" )
  {
    $pair = $_.split("=");

    # Set the environment variable for the current PowerShell session
    Set-Item -Force -Path "ENV:\$($pair[0])" -Value "$($pair[1])"
  }
}

# Move back to wherever the prompt was previously
popd

}
