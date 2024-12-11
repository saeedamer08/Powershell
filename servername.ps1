Param
(
    [string] $RuntimePath,
    [Parameter()] [ValidateSet('SET','TEST')] [string] $Command
)



    

$Script:Registration = @{

    TopdeskCall = '-'  # 'NEH-C2310 0449'  
    
    CustomerCode = ''  # 'NW'

    ComputerName = 'NPS02'  # 'NW-TESTVM01'

    OrganizationType = 'DOMAIN'          # 'DOMAIN','DMZ','XA' is not implemented,'XATEST' is not implemented

    DomainName = 'asp.'       # 'ASP.NEHWONEN.NL'

    DomainOUPath = 'DC=asp,DC=,DC=org,OU=Bedrijf,OU=Servers 2022,OU=Productie Servers'     # 'OU=Productie Servers,OU=Servers 2022,OU=Bedrijf,DC=asp,DC=nehwonen,DC=nl'

    UserInterfaceType = 'GUI'            # 'GUI' or 'CORE'
}
   

$Script:Management = [ordered] @{

    ServerName = 'NSS'
}

$Script:VMHost = [ordered] @{
    HostName = 'HVH'    # VMM VM Hostname
    VMLocation = "C:\ClusterStorage\SSD" # VMM VM Location
}


$Script:VM = [ordered] @{

    ComputerName = $Script:Registration.ComputerName

    OperatingSystem = 'Windows Server 2022 Standard'  # VMM VM OperatingSystem

    Description = ''                                  # Currently not used

    Generation = 2                                    # VMM VM Generation

    CPUType = '3.60 GHz Xeon (2 MB L2 cache)'         # VMM VM CPUType
    CPUCount = 2                                      # VMM VM CPU count

    MemoryMB = 6144                                   # VMM VM Memory in MB
    DynamicMemoryEnabled = $false                     # VMM VM Dynamic Memory

    Disks = @(
        @{
            BusType = 'SCSI'  # IDE
            Bus = 0
            Lun = 0
            IsVirtualHarddisk = $true
            Filename = "$($Script:Registration.ComputerName)_DISK_1.vhdx"
            VolumeType = 'BootAndSystem'
            DeploymentOption = 'UseNetwork'
        }
#        ,
#        @{
#            BusType = 'SCSI'
#            Bus = 0
#            Lun = 1                                       # Per disk ophogen
#            SizeType = 'Fixed' 
#            VirtualHardDiskSizeMB = 40 * 1024             # 40GB
#            VolumeType = 'None'
#            Filename = "$($Script:Registration.ComputerName)_DISK_2.vhdx"
#            DeploymentOption = 'None'
#            PinFilename = $false
#        }
    )
        
    
    VMSwitch = 'MGT-VM-NET-SWITCH'                    # VMM VM Switch
    VMNetwork = $Script:Registration.CustomerCode     # VMM VM Network
    VMLogicalNetwork = $Script:Registration.CustomerCode     # VMM VM LogicalNetwork

    VLanID = 77                                       # VMM Network VLANID

    Network = @(                                      # Windows OS, Network Adapter settings
        @{
            AddressFamily = 'IPV4'
            IPAddress = '172.21.77.62'
            PrefixLength = 24
            DefaultGateway = '172.21.77.1'
            Type = 'Unicast'
            InterfaceAlias = 'Ethernet 2'
        }
    )

    DNS = @{
        ServerAddresses = @('172.21.77.21','172.22.77.20')                    # Windows OS, Network DNS Servers
        InterfaceAlias = 'Ethernet 2'
    }

    WSUS = @{
        WSUSServer = '172.19.254.21'                  # Windows OS, WSUS Server
        PortNumber = '8530'                           # Windows OS, WSUS Portnumber
        TargetGroup = 'Beheer'                 # Windows OS, WSUS Targetgroup
    }


    CloudName = 'Cloud Zwolle'                    # VMM VM Cloudname 'Cloud NEH Zwolle' of 'Cloud NEH Ede'
        
    HostName = $Script:VMHost.HostName                                                   # Moeten in source komen te vervallen, waardes van $Host afhalen
    VMLocation = "$($Script:VMHost.VMLocation)\$($Script:Registration.CustomerCode)"     # 
        
    VHDXPath = "\\$($Script:Management.ServerName)\MSSCVMMLibrary\Images\Windows2022-HyperV$($Script:Registration.UserInterfaceType)-V*.vhdx"  # VMM VM VHDX Path

    CapabilityProfileName = 'hyper-v'                 # VMM VM Capability Profile Name

    ProductKey = 'N838F'      # Windows OS, Productkey

    GuestOSProfile = "$($Script:Registration.OperatingSystem) $($Script:Registration.UserInterfaceType) $($Script:Registration.CustomerCode)" # VMM VM Guest OS Profile

    TimeZoneIndex = 110                               # VMM VM Timezone Index [W. Europe Standard Time] 
                                                      # Zie url: https://learn.microsoft.com/en-us/previous-versions/windows/embedded/ms912391(v=winembedded.11)?redirectedfrom=MSDN

    OSTimeZone = 'W. Europe Standard Time'            # Windows OS, Timezone

    Folders = @('C:\Beheer\Install')                  # Windows OS, Filesystem Folders
}




#---------------------------------------------------------------------------------------------------------
#
# The following values must only be changed by Platform Development:
#
#---------------------------------------------------------------------------------------------------------


$Script:Info = @{
    Application = 'NEHCreateVM'
    Owner = 'NEH Platform Development'
    Creator = 'NEH Platform Development'
    Contact = 'beheer@nehgroup.com, m.v.beers@nehgroup.com'
    Description = 'Script creates a VM following the NEH Hyper-V Virtual Machine specifications'
}


$Script:NEHLogger = @{

    PowershellModule = 'C:\Beheer\NEHLogger.psm1'
    HTMLCSSFilename = 'Styles.css'
    Logfile = "$($RuntimePath)\Logging\$($Script:VM.ComputerName)_$(Get-Date -Format 'yyyyMMddHHmmss').html"
    Logfile_PurgeAfterDays = 366
}


$Script:CopyFilesToVMHost = @(
    @{
        Source = 'C:\Beheer\NEHConfigureVM.ps1' 
        Destination = "\\$($Script:VM.HostName)\C$\Beheer\Scripts\HyperV\Files\NEHConfigureVM.ps1"
    }
    @{
        Source = 'C:\Beheer\NEHLogger.psd1' 
        Destination = "\\$($Script:VM.HostName)\C$\Beheer\Scripts\HyperV\Files\NEHLogger.psd1"
    }
    @{
        Source = 'C:\Beheer\NEHLogger.psm1'
        Destination = "\\$($Script:VM.HostName)\C$\Beheer\Scripts\HyperV\Files\NEHLogger.psm1"
    }
    @{
        Source = 'C:\Beheer\Styles.css' 
        Destination = "\\$($Script:VM.HostName)\C$\Beheer\Scripts\HyperV\Files\Styles.css"   
    }
    @{
        Source = 'C:\Beheer\NEH-VM-Configure-Settings.ps1' 
        Destination = "\\$($Script:VM.HostName)\C$\Beheer\Scripts\HyperV\Files\NEH-VM-Configure-Settings.ps1"   
    }
)


$Script:CopyFilesToVM = @(
    @{
        Source = 'C:\Beheer\NEHConfigureVM.ps1' 
        Destination = "C:\Beheer\NEHConfigureVM.ps1"
    }
    @{
        Source = 'C:\Beheer\NEHLogger.psd1' 
        Destination = "C:\BeheerNEHLogger.psd1"
    }
    @{
        Source = 'C:\Beheer\NEHLogger.psm1'
        Destination = "C:\Beheer\NEHLogger.psm1"
    }
    @{
        Source = 'C:\Beheer\Styles.css' 
        Destination = "C:\Beheer\Styles.css"  
    }
    @{
        Source = 'C:\Beheer\NEH-VM-Configure-Settings.ps1' 
        Destination = "C:\Beheer\NEH-VM-Configure-Settings.ps1"   
    }
)


$Script:VMSetup = @{
    
    ConfigurationScript = 'C:\Beheer\Scripts\HyperV\Files\NEHConfigureVM.ps1' # Script running on VM resides on VMHost.

    ConfigurationData = @{
        
        Context = ""
        Command = $Command  # 'SET', 'TEST'
        Configure = $Script:Registration.UserInterfaceType

        ComputerName = $Script:VM.ComputerName
        DomainName = $Script:Registration.DomainName
        DomainOUPath = $Script:Registration.DomainOUPath
        OrganizationType = $Script:Registration.OrganizationType

        Description = $Script:VM.Description

        DomainCredential = $null
        LocalCredential = $null

        RuntimePath = 'C:\Beheer\Scripts\HyperV'
        SettingsFile = "$($RuntimePath)\NEH-VM-Configure-Settings.ps1"
        Logfile = "$($RuntimePath)\Logging\$($Script:VM.ComputerName)_$(Get-Date -Format 'yyyyMMddHHmmss').html"
        
        ProductKey = $Script:VM.ProductKey

        TimeZone = $Script:VM.OSTimeZone

        Folders = $Script:VM.Folders

        Network = $Script:VM.Network
        DNS = $Script:VM.DNS

        WSUS = $Script:VM.WSUS

        Interactive = $true
        LogLevel = '9'
    }
}


$Script:Settings = @{

    Info = $Script:Info
    Registration = $Script:Registration
    Management = $Script:Management

    VMHost = $Script:VMHost

    VM = $Script:VM
    VMSetup = $Script:VMSetup

    NEHLogger = $Script:NEHLogger
    CopyFilesToVMHost = $Script:CopyFilesToVMHost
    CopyFilesToVM = $Script:CopyFilesToVM
}

$Script:Settings
