﻿@{
	# Script module or binary module file associated with this manifest
	RootModule = 'WatchDog.psm1'

	# Version number of this module.
	ModuleVersion = '1.1.2'

	# ID used to uniquely identify this module
	GUID = '368f5935-0766-4c9a-aa12-6407c24998f1'

	# Author of this module
	Author = 'Sascha Spiekermann'

	# Company or vendor of this module
	CompanyName = 'MyCompany'

	# Copyright statement for this module
	Copyright = 'Copyright (c) 2023 Sascha Spiekermann'

	# Description of the functionality provided by this module
	Description = 'A configurable service watchdog'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.0'

	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @(
		@{ ModuleName='PSFramework'; ModuleVersion='1.9.310' }
	)

	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @('bin\WatchDog.dll')

	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @('xml\WatchDog.Types.ps1xml')

	# Format files (.ps1xml) to be loaded when importing this module
	# FormatsToProcess = @('xml\WatchDog.Format.ps1xml')

	# Functions to export from this module
	FunctionsToExport = @(
		'Build-WatchDog'
		'Get-WatchDogConfig'
		'Get-WatchDogError'
		'Register-WatchDog'
		'Remove-WatchDog'
		'Start-WatchDog'
		'Unregister-WatchDog'
	)

	# Cmdlets to export from this module
	CmdletsToExport = ''

	# Variables to export from this module
	VariablesToExport = ''

	# Aliases to export from this module
	AliasesToExport = ''

	# List of all modules packaged with this module
	ModuleList = @()

	# List of all files packaged with this module
	FileList = @()

	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{

		#Support for PowerShellGet galleries.
		PSData = @{

			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @('watchdog')

			# A URL to the license for this module.
			LicenseUri = 'https://github.com/Callidus2000/WatchDog/blob/master/LICENSE'

			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/Callidus2000/WatchDog'

			# A URL to an icon representing this module.
			# IconUri = ''

			# ReleaseNotes of this module
			ReleaseNotes = @"
# Breaking release 1.1.0
- The return value of the Check and Fix scriptblocks is discarded
- `throw` an exception in the scriptblocks to indicate an error
- README on GitHub got extra info for business logik
"@

		} # End of PSData hashtable

	} # End of PrivateData hashtable
}