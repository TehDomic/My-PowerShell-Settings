# Load the PSReadLine module
Import-Module PSReadLine

# --- PREDICTIONS & APPEARANCE ---
# Enable smart predictions from History and Plugins (New in 2.2+)
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineOption -Colors @{ InlinePrediction = '#5a5a5a' }
Set-PSReadLineOption -ShowToolTips

# --- KEY BINDINGS (FISH & LINUX STYLE) ---
# Accept suggestions with the Right Arrow key (Fish-style)
Set-PSReadLineKeyHandler -Key RightArrow -Function AcceptSuggestion

# Close PowerShell with Ctrl+D if the line is empty (Linux-style)
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function DeleteCharOrExit

# Smart History Search: Use arrows to search based on what you've already typed
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Preserve your existing preferences
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

# --- SECURITY & HYGIENE ---
# Prevent passwords/secrets from being saved to your history file (New in 2.4+)
Set-PSReadLineOption -AddToHistoryHandler {
    param($line)
    if ($line -like "*password*" -or $line -like "*secret*" -or $line -like "*token*") { return $false }
    return $true
}
