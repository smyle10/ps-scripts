$comShell = New-Object -ComObject Shell.Application
$dir = $comShell.NameSpace("D:\Photos\2021\test")
$file = $dir.items() | select -First 1
-1..255 | foreach {
    $dir.GetDetailsOf($file, $_) |
    where {
        -not [string]::IsNullOrWhiteSpace($_)
    }
}

#full example
Function Get-ExtendedFileProperties{ 
    [CMDLetBinding()]
    Param(
        [String]
        [ValidateScript({Test-Path $_})]
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        $Path
    )
    Begin{
        $ErrorActionPreference = 'Stop'

        $Shell = New-Object -ComObject Shell.Application 
    }
    Process{
        $FileMetaData = New-Object PSObject

        $Name = Get-Item $Path | Select-Object -ExpandProperty BaseName
        $Folder = Split-Path $Path -Parent

        $NameSpace = $Shell.Namespace($Folder) 
    
        $File = $NameSpace.Items() | Where-Object { $_.Name -match $Name }
    
        For($i=0 ; $i  -le 266; $i++){  
            If($NameSpace.GetDetailsOf($File, $i)){ 
                $Key = $NameSpace.GetDetailsOf($NameSpace.Items, $i)
                $Value = $NameSpace.GetDetailsOf($File, $i)
          
                $FileMetaData | Add-Member -MemberType NoteProperty -Name $Key -Value $Value
            }
        }

        $FileMetaData
    } 
}
