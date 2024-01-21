function New-Screenshot($Path = "C:\tmp") {
  # source: https://woshub.com/take-user-desktop-screenshot-with-powershell/

  # Make sure that the directory to keep screenshots has been created, otherwise create it
  If (!(test-path $path)) {
    New-Item -ItemType Directory -Force -Path $path
  }

  Add-Type -AssemblyName System.Windows.Forms

  $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds

  # Get the current screen resolution
  $image = New-Object System.Drawing.Bitmap($screen.Width, $screen.Height)

  # Create a graphic object
  $graphic = [System.Drawing.Graphics]::FromImage($image)
  $point = New-Object System.Drawing.Point(0, 0)
  $graphic.CopyFromScreen($point, $point, $image.Size);
  $cursorBounds = New-Object System.Drawing.Rectangle([System.Windows.Forms.Cursor]::Position, [System.Windows.Forms.Cursor]::Current.Size)

  # Get a screenshot
  [System.Windows.Forms.Cursors]::Default.Draw($graphic, $cursorBounds)

  $fileName = $env:computername + "_" + $env:username + "_" + "$((get-date).tostring('yyyy.MM.dd-HH.mm.ss')).png"
  $filePath = Join-Path -Path $Path -ChildPath $fileName

  # Save the screenshot as a PNG file
  $image.Save($screen_file, [System.Drawing.Imaging.ImageFormat]::Png)
}
