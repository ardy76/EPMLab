#requires -Version 4.0
<#
    .Synopsis
    ArdyLab DSC Resource to Build FileServer on a node.

    .Description
    blah, blah
    
    .TODO
    Add Error Checking and Verbose/Debug output
#>
Configuration LabDeployFileServer
{
  param             
  ( 
    [Parameter(Mandatory)]             
    [psobject]
    $MountVHD       
  )

  Import-DscResource -ModuleName xSmbShare, xStorage, PSDesiredStateConfiguration 
        
  foreach ($VHD in $MountVHD)
  {   
    # Mount the disk in Windows                  
    xDisk $VHD.ShareName
    {
      DriveLetter = $VHD.DriveLetter
      DiskNumber = $VHD.DiskNumber            
    }
        
    # Create a share for the mounted disk
    xSmbShare $VHD.ShareName
    {
      Name = $VHD.ShareName
      Path = "$($VHD.DriveLetter):\"
      Ensure = 'Present'
      DependsOn = "[xDisk]$($VHD.ShareName)"
    }
  }
}