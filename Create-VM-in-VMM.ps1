Param
(
    [string] $RuntimePath,
    [Parameter()] [ValidateSet('SET','TEST')] [string] $Command
)



    

$Script:Registration = @{

    TopdeskCall = '-'  # ''  
    
    CustomerCode = ''  # ''

    ComputerName = ''  # ''

    OrganizationType = 'DOMAIN'          						# 'DOMAIN','DMZ','XA' is not implemented

    DomainName = 'asp'		       								# 'ASP'

    DomainOUPath = 'DC='    		 							# 'OU=,OU='

    UserInterfaceType = 'GUI'           		 				# 'GUI' or 'CORE'
}
   

$Script:Management = [ordered] @{

    ServerName = ''
}

$Script:VMHost = [ordered] @{
    HostName = ''    											# VMM VM Hostname
    VMLocation = "" 											# VMM VM Location
}


$Script:VM = [ordered] @{

    ComputerName = $Script:Registration.ComputerName

    OperatingSystem = 'Windows Server 2022 Standard'  			# VMM VM OperatingSystem

    Description = ''                                  			# Currently not used

    Generation = 2                                    			# VMM VM Generation

    CPUType = '3.60 GHz Xeon (2 MB L2 cache)'         			# VMM VM CPUType
    CPUCount = 2                                      			# VMM VM CPU count

    MemoryMB = 6144                                   			# VMM VM Memory in MB
    DynamicMemoryEnabled = $false                     			# VMM VM Dynamic Memory

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
    )
        
    
    VMSwitch = ''				                    			# VMM VM Switch
    VMNetwork = $Script:Registration.CustomerCode     			# VMM VM Network
    VMLogicalNetwork = $Script:Registration.CustomerCode    	# VMM VM LogicalNetwork

    VLanID =                                        			# VMM Network VLANID

    Network = @(                                      																						# Windows OS, Network Adapter settings
        @{
            AddressFamily = 'IPV4'
            IPAddress = ''
            PrefixLength = 24
            DefaultGateway = ''
            Type = 'Unicast'
            InterfaceAlias = 'Ethernet 2'
        }
    )

    DNS = @{
        ServerAddresses = @('')       																											# Windows OS, Network DNS Servers
        InterfaceAlias = 'Ethernet 2'
    }

    WSUS = @{
        WSUSServer = ''      			            																							# Windows OS, WSUS Server
        PortNumber = '8530'                           																							# Windows OS, WSUS Portnumber
        TargetGroup = ''               		  																									# Windows OS, WSUS Targetgroup
    }


    CloudName = ''                  	  																										# VMM 	
        
    HostName = $Script:VMHost.HostName                                                  
    VMLocation = ""    																															# 
        
    VHDXPath = "\\"  																															# VMM VM VHDX Path

    CapabilityProfileName = ''                 																									# VMM VM Capability Profile Name

    ProductKey = ''      																														# Windows OS, Productkey

    GuestOSProfile = "$($Script:Registration.OperatingSystem) $($Script:Registration.UserInterfaceType) $($Script:Registration.CustomerCode)"	# VMM VM Guest OS Profile

    TimeZoneIndex = 110                               																							# VMM VM Timezone Index [W. Europe Standard Time] 
                                                      # Zie url: https://learn.microsoft.com/en-us/previous-versions/windows/embedded/ms912391(v=winembedded.11)?redirectedfrom=MSDN

    OSTimeZone = 'W. Europe Standard Time'            																							# Windows OS, Timezone

    Folders = @('C:\Beheer\Install')                  																							# Windows OS, Filesystem Folders
}




#---------------------------------------------------------------------------------------------------------
#
# The following values must only be changed by Platform Development:
#
#---------------------------------------------------------------------------------------------------------


$Script:Info = @{
    Application = 'NEHCreateVM'
    Owner = ''
    Creator = ''
    Contact = ''
    Description = 'Script creates a VM following the NEH Hyper-V Virtual Machine specifications'
}


$Script:Logger = @{

    PowershellModule = ''
    HTMLCSSFilename = ''
    Logfile = "$($RuntimePath)\Logging\$($Script:VM.ComputerName)_$(Get-Date -Format 'yyyyMMddHHmmss').html"
    Logfile_PurgeAfterDays = 366
}


$Script:CopyFilesToVMHost = @(
    @{
        Source = '' 
        Destination = ""
    }
    @{
        Source = '' 
        Destination = ""
    }
    @{
        Source = ''
        Destination = ""
    }
    @{
        Source = '' 
        Destination = ""   
    }
    @{
        Source = '' 
        Destination = ""   
    }
)


$Script:CopyFilesToVM = @(
    @{
        Source = '' 
        Destination = ""
    }
    @{
        Source = '' 
        Destination = ""
    }
    @{
        Source = ''
        Destination = ""
    }
    @{
        Source = '' 
        Destination = ""  
    }
    @{
        Source = '' 
        Destination = ""   
    }
)


$Script:VMSetup = @{
    
    ConfigurationScript = ''													# Script running on VM resides on VMHost.

    ConfigurationData = @{
        
        Context = ""
        Command = $Command																# 'SET', 'TEST'
        Configure = $Script:Registration.UserInterfaceType

        ComputerName = $Script:VM.ComputerName
        DomainName = $Script:Registration.DomainName
        DomainOUPath = $Script:Registration.DomainOUPath
        OrganizationType = $Script:Registration.OrganizationType

        Description = $Script:VM.Description

        DomainCredential = $null
        LocalCredential = $null

        RuntimePath = ''
        SettingsFile = ""
        Logfile = ""
        
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
