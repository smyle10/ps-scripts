Get-ChildItem | ForEach-Object -Process {
    if (-not ((Get-ChildItem $_).target | Get-ChildItem 2> $null)) {
        Move-Item $_ ../broken
    }
}
