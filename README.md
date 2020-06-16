## StaxripBetaDownload

This small Powershell script checks and downloads the latest version (stable and beta) of [StaxRip](https://github.com/staxrip/staxrip) - at the moment only from DropBox.

------

## Usage

1. Check for latest version and download it to current directory if it doesn't exist yet:
```Powershell
StaxripBetaDownload.ps1
```

2. Check for latest version and download it after confirmation to current directory if it doesn't exist there yet:
```Powershell
StaxripBetaDownload.ps1 -ConfirmDownload
```

3. Check for latest version and download it to `A:\Apps\StaxRip` if it doesn't exist there yet:
```Powershell
StaxripBetaDownload.ps1 -DownloadDirectory A:\Apps\StaxRip
```

4. Check for latest version and download it to current directory if it doesn't exist there yet. Use the current DropBox link from the docs instead of the one saved in this script:
```Powershell
StaxripBetaDownload.ps1 -GetDropboxUrlFromDoc
```


