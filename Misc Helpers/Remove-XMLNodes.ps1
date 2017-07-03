<#
.SYNOPSIS
Remove child nodes from an xml file by a given INNER TEXT
#>

# Some sort of config file
[xml]$xml = @"
<Connections>

  <Connection>
    <ConnectionType>RDPConfigured</ConnectionType>
    <Name>SERVER1</Name>
    <Url>SERVER1</Url>
    <Description>My Super Server</Description>
  </Connection>

  <Connection>
    <ConnectionType>RDPConfigured</ConnectionType>
    <Name>SERVER2</Name>
    <Url>SERVER2</Url>
    <Description>My Super Server</Description>
  </Connection>

  <Connection>
    <ConnectionType>RDPConfigured</ConnectionType>
    <Name>SERVER1</Name>
    <Url>SERVER1</Url>
    <Description>Just another Server</Description>
  </Connection>

 </Connections>
"@

# we search for this:
$SearchTerm = "My Super Server"

# search attribute
$attrib = "Description"

# Example node finding. Findes only the first on. We need to start somewhere ...
$node = $xml.SelectSingleNode("//$attrib[.='$SearchTerm']")
# While there is another node
while ($node -ne $null) {

    # Remove the node itself
    # $node.ParentNode.RemoveChild($node)

    # Remove ALL the child-Nodes from this nodes parent
    $node.ParentNode.RemoveAll()

    # Get the nexe node
    $node = $xml.SelectSingleNode("//$attrib[.='$SearchTerm']")
}


# Detect empty nodes
$nodes = $xml.SelectNodes("//*[count(@*) = 0 and count(child::*) = 0 and not(string-length(text())) > 0]")

# Delete empty nodes
$nodes | ForEach-Object {
    $_.ParentNode.RemoveChild($_)
}

# Okay, so we need to save the new XML
$xml.Save("C:\temp\test.xml")
