# PowerShell 7.5 script to test latency for IPs in 104.26.0.0/24 and return top 5 with lowest latency

# Define the function to test ping latency for a single IP
function Test-IpLatency {
    param (
        [string]$IpAddress
    )
    try {
        # Perform ping with 2 attempts
        $ping = Test-Connection -ComputerName $IpAddress -Count 2 -Delay 1 -ErrorAction Stop
        # Calculate average latency, ensuring only valid responses are considered
        $validPings = $ping | Where-Object { $_.Status -eq 'Success' }
        if ($validPings) {
            $avgLatency = ($validPings | Measure-Object -Property Latency -Average).Average
            return [PSCustomObject]@{
                IP = $IpAddress
                Latency = [math]::Round($avgLatency, 2) # Round to 2 decimal places
            }
        }
        else {
            # No successful pings
            return [PSCustomObject]@{
                IP = $IpAddress
                Latency = [double]::MaxValue
            }
        }
    }
    catch {
        # Handle cases where ping fails entirely (e.g., host unreachable)
        return [PSCustomObject]@{
            IP = $IpAddress
            Latency = [double]::MaxValue
        }
    }
}

# Generate IP list for 104.26.0.0/24
$ipList = 0..255 | ForEach-Object { "104.26.0.$_" }

# Test latency for all IPs in parallel
$results = $ipList | ForEach-Object -Parallel {
    # Redefine the function inside the parallel scope
    function Test-IpLatency {
        param (
            [string]$IpAddress
        )
        try {
            $ping = Test-Connection -ComputerName $IpAddress -Count 2 -Delay 1 -ErrorAction Stop
            $validPings = $ping | Where-Object { $_.Status -eq 'Success' }
            if ($validPings) {
                $avgLatency = ($validPings | Measure-Object -Property Latency -Average).Average
                return [PSCustomObject]@{
                    IP = $IpAddress
                    Latency = [math]::Round($avgLatency, 2)
                }
            }
            else {
                return [PSCustomObject]@{
                    IP = $IpAddress
                    Latency = [double]::MaxValue
                }
            }
        }
        catch {
            return [PSCustomObject]@{
                IP = $IpAddress
                Latency = [double]::MaxValue
            }
        }
    }
    Test-IpLatency -IpAddress $_
} -ThrottleLimit 50

# Filter out unreachable IPs, sort by latency, and select top 5
$top5 = $results | 
    Where-Object { $_.Latency -ne [double]::MaxValue } | 
    Sort-Object Latency | 
    Select-Object -First 5

# Output results
Write-Host "Top 5 IPs with lowest latency (in ms):"
$top5 | Format-Table -AutoSize