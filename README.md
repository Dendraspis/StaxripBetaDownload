## Deprecated because of changed ownership, versioning and changed publication of StaxRip.

-------

### StaxripBetaDownload

This small Powershell script checks and downloads the latest beta version of [StaxRip](https://github.com/staxrip/staxrip) - at the moment only from DropBox.

------

### Usage

1. Check for latest beta version and download it to current directory if it doesn't exist there yet:
```Powershell
StaxripBetaDownload.ps1
```

2. Check for latest beta version and download it after confirmation to current directory if it doesn't exist there yet:
```Powershell
StaxripBetaDownload.ps1 -ConfirmDownload
```

3. Check for latest beta version and download it to `A:\Downloaded Apps\StaxRip` if it doesn't exist there yet - directory is going to be created if it doesn't exist yet:
```Powershell
StaxripBetaDownload.ps1 -DownloadDirectory "A:\Downloaded Apps\StaxRip"
```

4. Check for latest beta version and download it to current directory if it doesn't exist there yet. Use the current DropBox link from the docs instead of the one saved in this script:
```Powershell
StaxripBetaDownload.ps1 -GetDropboxUrlFromDoc
```


