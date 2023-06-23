# apt-winget

## purpose
when installing software I tend to use winget and wanted a more convenient way to search and install software packages.

**NOTE:** ***as I personally only use winget packages (as I had issues when msstore launched) the script is filtering for only winget packages!***

## installation

* edit the profile-file by running `notepad $profile` in a PowerShell console
* add all functions from `apt-winget.ps1` to profile-file
* restart PowerShell console

## known issues

`winget` must be run at least once to be initialized

## usage

### search for package

    apt search workrave

lists all winget packages for the search term `workrave` adding numbers in front of each package found to select and install it. by hitting `enter`-key without number the prompt exits without installing anything.

### output

    PS C:\Users\gpunktschmitz> apt search workrave
    [1] :: Workrave - (Workrave.Workrave)
    enter number to install package (ENTER to exit):

### install multiple packages

    apt install firefox vscode

searches for winget packages `firefox` and `vscode`. if only one package is found the package is installed without further prompt. if more than one package is found a prompt is shown to select a package and install it.

### output

![using apt function to install firefox and vscode](https://raw.github.com/gpunktschmitz/scripts/ps1/apt-winget/docu/apt-winget-firefox-vscode.png)
