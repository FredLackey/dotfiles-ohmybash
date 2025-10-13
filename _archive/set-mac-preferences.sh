#!/bin/bash

# Set macOS system preferences
# This script configures various macOS system settings

set_dock_preferences() {
    echo "Setting Dock preferences..."
    
    # Automatically hide/show the Dock
    defaults write com.apple.dock autohide -bool true
    # Disable the hide Dock delay
    defaults write com.apple.dock autohide-delay -float 0
    # Enable spring loading for all Dock items
    defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
    # Make all Mission Control related animations faster
    defaults write com.apple.dock expose-animation-duration -float 0.1
    # Do not group windows by application in Mission Control
    defaults write com.apple.dock expose-group-by-app -bool false
    # Disable the opening of an application from the Dock animations
    defaults write com.apple.dock launchanim -bool false
    # Change minimize/maximize window effect
    defaults write com.apple.dock mineffect -string 'scale'
    # Reduce clutter by minimizing windows into their application icons
    defaults write com.apple.dock minimize-to-application -bool true
    # Do not automatically rearrange spaces based on most recent use
    defaults write com.apple.dock mru-spaces -bool false
    # Wipe all app icons
    defaults write com.apple.dock persistent-apps -array
    defaults write com.apple.dock persistent-others -array
    # Show indicator lights for open applications
    defaults write com.apple.dock show-process-indicators -bool true
    # Do not show recent applications in Dock
    defaults write com.apple.dock show-recents -bool false
    # Make icons of hidden applications translucent
    defaults write com.apple.dock showhidden -bool true
    
    killall "Dock" &> /dev/null
}

set_finder_preferences() {
    echo "Setting Finder preferences..."
    
    # Automatically open a new Finder window when a volume is mounted
    defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
    defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
    defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
    # Use full POSIX path as window title
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
    # Disable all animations
    defaults write com.apple.finder DisableAllAnimations -bool true
    # Disable the warning before emptying the Trash
    defaults write com.apple.finder WarnOnEmptyTrash -bool false
    # Search the current directory by default
    defaults write com.apple.finder FXDefaultSearchScope -string 'SCcf'
    # Disable warning when changing a file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    # Use list view in all Finder windows by default
    defaults write com.apple.finder FXPreferredViewStyle -string 'Nlsv'
    # Set 'Desktop' as the default location for new Finder windows
    defaults write com.apple.finder NewWindowTarget -string 'PfDe'
    defaults write com.apple.finder NewWindowTargetPath -string 'file://$HOME/Desktop/'
    # Show icons for hard drives, servers, and removable media on the desktop
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
    # Do not show recent tags
    defaults write com.apple.finder ShowRecentTags -bool false
    # Hide all filename extensions
    defaults write -g AppleShowAllExtensions -bool false
    
    # Set sort method
    /usr/libexec/PlistBuddy -c 'Set :DesktopViewSettings:IconViewSettings:arrangeBy none' ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c 'Set :StandardViewSettings:IconViewSettings:arrangeBy none' ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    
    killall "Finder" &> /dev/null
    killall "cfprefsd" &> /dev/null
}

set_keyboard_preferences() {
    echo "Setting Keyboard preferences..."
    
    # Enable full keyboard access for all controls
    defaults write -g AppleKeyboardUIMode -int 3
    # Disable press-and-hold in favor of key repeat
    defaults write -g ApplePressAndHoldEnabled -bool false
    # Set delay until repeat
    defaults write -g 'InitialKeyRepeat_Level_Saved' -int 10
    # Set the key repeat rate to fast
    defaults write -g KeyRepeat -int 1
    # Disable automatic capitalization
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
    # Disable automatic correction
    defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
    # Disable automatic period substitution
    defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
    # Disable smart dashes
    defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
    # Disable smart quotes
    defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
    # Remap the emoji picker to the Fn key
    defaults write com.apple.HIToolbox AppleFnUsageType -int 2
}

set_safari_preferences() {
    echo "Setting Safari preferences..."
    
    # Disable opening 'safe' files automatically
    defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
    # Set backspace key to go to the previous page in history
    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true
    # Enable the 'Develop' menu and the 'Web Inspector'
    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
    defaults write com.apple.Safari IncludeDevelopMenu -bool true
    defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
    # Set search type to 'Contains' instead of 'Starts With'
    defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
    # Set home page to 'about:blank'
    defaults write com.apple.Safari HomePage -string 'about:blank'
    # Enable 'Debug' menu
    defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
    # Hide bookmarks bar by default
    defaults write com.apple.Safari ShowFavoritesBar -bool false
    # Show the full URL in the address bar
    defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
    # Don't send search queries to Apple
    defaults write com.apple.Safari SuppressSearchSuggestions -bool true
    defaults write com.apple.Safari UniversalSearchEnabled -bool false
    # Add a context menu item for showing the 'Web Inspector' in web views
    defaults write -g WebKitDeveloperExtras -bool true
    # Disable the standard delay in rendering a web page
    defaults write com.apple.Safari WebKitInitialTimedLayoutDelay 0.25
    
    killall "Safari" &> /dev/null
}

set_chrome_preferences() {
    echo "Setting Chrome preferences..."
    
    # Disable backswipe
    defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
    # Expand print dialog by default
    defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
    # Use system-native print preview dialog
    defaults write com.google.Chrome DisablePrintPreview -bool true
    
    killall "Google Chrome" &> /dev/null
}

set_terminal_preferences() {
    echo "Setting Terminal preferences..."
    
    # Make the focus automatically follow the mouse
    defaults write com.apple.terminal FocusFollowsMouse -string true
    # Enable 'Secure Keyboard Entry'
    defaults write com.apple.terminal SecureKeyboardEntry -bool true
    # Hide line marks
    defaults write com.apple.Terminal ShowLineMarks -int 0
    # Only use UTF-8
    defaults write com.apple.terminal StringEncodings -array 4
    
    # Use Touch ID for sudo if available
    # if ! grep -q "pam_tid.so" "/etc/pam.d/sudo"; then
    #     sudo sed -i '' '1s;^;auth       sufficient     pam_tid.so\n;' /etc/pam.d/sudo
    # fi
}

set_trackpad_preferences() {
    echo "Setting Trackpad preferences..."
    
    # Enable 'Tap to click'
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
    defaults write -g com.apple.mouse.tapBehavior -int 1
    defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
    # Map 'click or tap with two fingers' to the secondary click
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
    defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1
    defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0
    defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0
    defaults -currentHost write -g com.apple.trackpad.trackpadCornerClickBehavior -int 0
}

set_ui_ux_preferences() {
    echo "Setting UI & UX preferences..."
    
    # Avoid creating '.DS_Store' files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    # Hide battery percentage from the menu bar
    defaults write com.apple.menuextra.battery ShowPercent -string 'NO'
    # Make crash reports appear as notifications
    defaults write com.apple.CrashReporter UseUNC 1
    # Disable 'Are you sure you want to open this application?' dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false
    # Automatically quit the printer app once the print jobs are completed
    defaults write com.apple.print.PrintingPrefs 'Quit When Finished' -bool true
    # Disable shadow in screenshots
    defaults write com.apple.screencapture disable-shadow -bool true
    # Save screenshots to the Screenshots folder
    defaults write com.apple.screencapture location -string '$HOME/Screenshots'
    # Do not show thumbnail
    defaults write com.apple.screencapture show-thumbnail -bool false
    # Save screenshots as PNGs
    defaults write com.apple.screencapture type -string 'png'
    # Require password immediately after into sleep or screen saver mode
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0
    # Enable subpixel font rendering on non-Apple LCDs
    defaults write -g AppleFontSmoothing -int 2
    # Always show scrollbars
    defaults write -g AppleShowScrollBars -string 'Always'
    # Disable window opening and closing animations
    defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
    # Disable automatic termination of inactive apps
    defaults write -g NSDisableAutomaticTermination -bool true
    # Expand save panel by default
    defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
    # Disable the over-the-top focus ring animation
    defaults write -g NSUseAnimatedFocusRing -bool false
    # Accelerated playback when adjusting the window size
    defaults write -g NSWindowResizeTime -float 0.001
    # Expand print panel by default
    defaults write -g PMPrintingExpandedStateForPrint -bool true
    # Disable opening a Quick Look window animations
    defaults write -g QLPanelAnimationDuration -float 0
    # Disable resume system-wide
    defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
    # Restart automatically if the computer freezes
    sudo systemsetup -setrestartfreeze on 2>/dev/null || echo "Note: System restart on freeze setting may require different permissions"
    
    # Hide Time Machine icon from the menu bar (updated for macOS Sequoia)
    for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
        sudo defaults write "${domain}" dontAutoLoad -array '/System/Library/CoreServices/Menu Extras/TimeMachine.menu' 2>/dev/null || true
    done
    sudo defaults write com.apple.systemuiserver menuExtras -array \
        '/System/Library/CoreServices/Menu Extras/Bluetooth.menu' \
        '/System/Library/CoreServices/Menu Extras/AirPort.menu' \
        '/System/Library/CoreServices/Menu Extras/Battery.menu' \
        '/System/Library/CoreServices/Menu Extras/Volume.menu' \
        '/System/Library/CoreServices/Menu Extras/Clock.menu' 2>/dev/null || echo "Note: Menu bar customization may be limited in this macOS version"
    
    killall "SystemUIServer" &> /dev/null
}

set_security_preferences() {
    echo "Setting Security & Privacy preferences..."
    
    # Disable personalized ads (updated for macOS Sequoia)
    defaults write com.apple.AdLib allowApplePersonalizedAdvertising -int 0 2>/dev/null || echo "Note: Personalized ads setting may not be available in this macOS version"
}

set_language_preferences() {
    echo "Setting Language & Region preferences..."
    
    # Set language
    defaults write -g AppleLanguages -array 'en'
}

set_maps_preferences() {
    echo "Setting Maps preferences..."
    
    # Set view options (updated mapType for macOS Sequoia)
    defaults write com.apple.Maps LastClosedWindowViewOptions '{
        localizeLabels = 1;
        mapType = 0;
        trafficEnabled = 0;
    }'
    
    killall "Maps" &> /dev/null
}

set_photos_preferences() {
    echo "Setting Photos preferences..."
    
    # Prevent Photos from opening automatically when devices are plugged in
    defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
    
    killall "Photos" &> /dev/null
}

set_textedit_preferences() {
    echo "Setting TextEdit preferences..."
    
    # Open and save files as UTF-8 encoded
    defaults write com.apple.TextEdit PlainTextEncoding -int 4
    defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
    # Use plain text mode for new documents
    defaults write com.apple.TextEdit RichText 0
    
    killall "TextEdit" &> /dev/null
}

set_firefox_preferences() {
    echo "Setting Firefox preferences..."
    
    # Disable backswipe
    defaults write org.mozilla.firefox AppleEnableSwipeNavigateWithScrolls -bool false
    
    killall "firefox" &> /dev/null
}

set_appstore_preferences() {
    echo "Setting App Store preferences..."
    
    # Enable debug menu
    defaults write com.apple.appstore ShowDebugMenu -bool true
    # Turn on auto-update
    defaults write com.apple.commerce AutoUpdate -bool true
    # Enable automatic update check
    defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
    # Download newly available updates in background
    defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
    # Install System data files and security updates
    defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
    
    killall "App Store" &> /dev/null
}

main() {
    echo "Setting macOS preferences..."
    
    set_dock_preferences
    set_finder_preferences
    set_keyboard_preferences
    set_safari_preferences
    set_chrome_preferences
    set_terminal_preferences
    set_trackpad_preferences
    set_ui_ux_preferences
    set_security_preferences
    set_language_preferences
    set_maps_preferences
    set_photos_preferences
    set_textedit_preferences
    set_firefox_preferences
    set_appstore_preferences
    
    echo "macOS preferences configuration completed!"
}

main
