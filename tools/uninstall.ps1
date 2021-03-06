param($installPath, $toolsPath, $package, $project)

function Get-SolutionDir {
    if($dte.Solution -and $dte.Solution.IsOpen) {
        return Split-Path $dte.Solution.Properties.Item("Path").Value
    }
    else {
        throw "Solution not avaliable"
    }
}

$solutionDir = Get-SolutionDir

Add-Type -AssemblyName 'Microsoft.Build, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'

$msbuild = [Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GetLoadedProjects($project.FullName) | Select-Object -First 1

$msbuild.Xml.Imports | Where-Object {$_.Project.ToLowerInvariant().EndsWith("lesscompiler.targets") } | Foreach { 
	$_.Parent.RemoveChild( $_ ) 
}

$project.Object.Refresh()
$project.Save()