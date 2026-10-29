{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;

      # Black + bright green color scheme. outOfStoreConfig keeps
      # ~/.config/noctalia live-editable via noctalia's own settings UI
      # (autoCopyConfig only seeds files that don't already exist there),
      # rather than locking the whole config dir to a read-only store path.
      outOfStoreConfig = "/home/akarp0508/.config/noctalia/";

      settings = {
        settingsVersion = 59;
        bar = {
          barType = "simple";
          position = "top";
          monitors = [ ];
          density = "comfortable";
          showOutline = false;
          showCapsule = true;
          capsuleOpacity = 1;
          capsuleColorKey = "none";
          widgetSpacing = 4;
          contentPadding = 2;
          fontScale = 1.04;
          enableExclusionZoneInset = true;
          backgroundOpacity = 0.93;
          useSeparateOpacity = false;
          marginVertical = 4;
          marginHorizontal = 4;
          frameThickness = 8;
          frameRadius = 12;
          outerCorners = false;
          hideOnOverview = false;
          displayMode = "always_visible";
          autoHideDelay = 500;
          autoShowDelay = 150;
          showOnWorkspaceSwitch = true;
          widgets = {
            left = [
              {
                colorizeSystemIcon = "none";
                colorizeSystemText = "none";
                customIconPath = "";
                enableColorization = false;
                icon = "rocket";
                iconColor = "none";
                id = "Launcher";
                useDistroLogo = false;
              }
              {
                clockColor = "none";
                customFont = "";
                formatHorizontal = "HH:mm ddd, MMM dd";
                formatVertical = "HH mm - dd MM";
                id = "Clock";
                tooltipFormat = "HH:mm ddd, MMM dd";
                useCustomFont = false;
              }
              {
                colorizeIcons = false;
                hideMode = "hidden";
                id = "ActiveWindow";
                maxWidth = 145;
                scrollingMode = "hover";
                showIcon = true;
                showText = true;
                textColor = "none";
                useFixedWidth = false;
              }
              {
                compactMode = false;
                hideMode = "hidden";
                hideWhenIdle = false;
                id = "MediaMini";
                maxWidth = 145;
                panelShowAlbumArt = true;
                scrollingMode = "hover";
                showAlbumArt = true;
                showArtistFirst = true;
                showProgressRing = true;
                showVisualizer = false;
                textColor = "none";
                useFixedWidth = false;
                visualizerType = "linear";
              }
            ];
            center = [
              {
                characterCount = 2;
                colorizeIcons = false;
                emptyColor = "secondary";
                enableScrollWheel = true;
                focusedColor = "primary";
                followFocusedScreen = false;
                fontWeight = "bold";
                groupedBorderOpacity = 1;
                hideUnoccupied = false;
                iconScale = 0.9;
                id = "Workspace";
                labelMode = "none";
                occupiedColor = "secondary";
                pillSize = 0.6;
                showApplications = true;
                showApplicationsHover = false;
                showBadge = true;
                showLabelsOnlyWhenOccupied = false;
                unfocusedIconsOpacity = 1;
              }
            ];
            right = [
              {
                blacklist = [ ];
                chevronColor = "none";
                colorizeIcons = false;
                drawerEnabled = true;
                hidePassive = false;
                id = "Tray";
                pinned = [ ];
              }
              {
                hideWhenZero = false;
                hideWhenZeroUnread = false;
                iconColor = "none";
                id = "NotificationHistory";
                showUnreadBadge = true;
                unreadBadgeColor = "primary";
              }
              {
                compactMode = true;
                diskPath = "/";
                iconColor = "none";
                id = "SystemMonitor";
                showCpuCores = false;
                showCpuFreq = false;
                showCpuTemp = true;
                showCpuUsage = true;
                showDiskAvailable = false;
                showDiskUsage = false;
                showDiskUsageAsPercent = false;
                showGpuTemp = false;
                showLoadAverage = false;
                showMemoryAsPercent = false;
                showMemoryUsage = true;
                showNetworkStats = false;
                showSwapUsage = false;
                textColor = "none";
                useMonospaceFont = true;
                usePadding = false;
              }
              {
                deviceNativePath = "__default__";
                displayMode = "graphic-clean";
                hideIfIdle = false;
                hideIfNotDetected = true;
                id = "Battery";
                showNoctaliaPerformance = false;
                showPowerProfiles = false;
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Volume";
                middleClickCommand = "pwvucontrol || pavucontrol";
                textColor = "none";
              }
              {
                colorizeDistroLogo = false;
                colorizeSystemIcon = "none";
                colorizeSystemText = "none";
                customIconPath = "";
                enableColorization = false;
                icon = "noctalia";
                id = "ControlCenter";
                useDistroLogo = false;
              }
            ];
          };
          mouseWheelAction = "none";
          reverseScroll = false;
          mouseWheelWrap = true;
          middleClickAction = "none";
          middleClickFollowMouse = false;
          middleClickCommand = "";
          rightClickAction = "controlCenter";
          rightClickFollowMouse = true;
          rightClickCommand = "";
          screenOverrides = [ ];
        };
        general = {
          avatarImage = "/home/akarp0508/.face";
          dimmerOpacity = 0.2;
          showScreenCorners = false;
          forceBlackScreenCorners = false;
          scaleRatio = 1;
          radiusRatio = 1;
          iRadiusRatio = 1;
          boxRadiusRatio = 1;
          screenRadiusRatio = 1;
          animationSpeed = 1;
          animationDisabled = false;
          compactLockScreen = false;
          lockScreenAnimations = false;
          lockOnSuspend = true;
          showSessionButtonsOnLockScreen = true;
          showHibernateOnLockScreen = false;
          enableLockScreenMediaControls = false;
          enableShadows = true;
          enableBlurBehind = true;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;
          language = "";
          allowPanelsOnScreenWithoutBar = true;
          showChangelogOnStartup = true;
          telemetryEnabled = false;
          enableLockScreenCountdown = true;
          lockScreenCountdownDuration = 10000;
          autoStartAuth = false;
          allowPasswordWithFprintd = false;
          clockStyle = "custom";
          clockFormat = "hh\nmm";
          passwordChars = false;
          lockScreenMonitors = [ ];
          lockScreenBlur = 0;
          lockScreenTint = 0;
          keybinds = {
            keyUp = [ "Up" ];
            keyDown = [ "Down" ];
            keyLeft = [ "Left" ];
            keyRight = [ "Right" ];
            keyEnter = [ "Return" "Enter" ];
            keyEscape = [ "Esc" ];
            keyRemove = [ "Del" ];
          };
          reverseScroll = false;
          smoothScrollEnabled = true;
        };
        ui = {
          fontDefault = "Sans Serif";
          fontFixed = "monospace";
          fontDefaultScale = 1;
          fontFixedScale = 1;
          tooltipsEnabled = true;
          scrollbarAlwaysVisible = true;
          boxBorderEnabled = false;
          panelBackgroundOpacity = 0.85;
          translucentWidgets = false;
          panelsAttachedToBar = true;
          settingsPanelMode = "attached";
          settingsPanelSideBarCardStyle = false;
        };
        location = {
          name = "Warsaw";
          weatherEnabled = true;
          weatherShowEffects = true;
          weatherTaliaMascotAlways = false;
          useFahrenheit = false;
          use12hourFormat = false;
          showWeekNumberInCalendar = false;
          showCalendarEvents = true;
          showCalendarWeather = true;
          analogClockInCalendar = false;
          firstDayOfWeek = -1;
          hideWeatherTimezone = false;
          hideWeatherCityName = false;
          autoLocate = false;
        };
        calendar = {
          cards = [
            { enabled = true; id = "calendar-header-card"; }
            { enabled = true; id = "calendar-month-card"; }
            { enabled = true; id = "weather-card"; }
          ];
        };
        wallpaper = {
          enabled = true;
          overviewEnabled = false;
          directory = "/home/akarp0508/Pictures/Wallpapers";
          monitorDirectories = [ ];
          enableMultiMonitorDirectories = false;
          showHiddenFiles = false;
          viewMode = "single";
          setWallpaperOnAllMonitors = true;
          linkLightAndDarkWallpapers = true;
          fillMode = "crop";
          fillColor = "#000000";
          useSolidColor = false;
          solidColor = "#1a1a2e";
          automationEnabled = false;
          wallpaperChangeMode = "random";
          randomIntervalSec = 300;
          transitionDuration = 1500;
          transitionType = [ "fade" "disc" "stripes" "wipe" "pixelate" "honeycomb" ];
          skipStartupTransition = false;
          transitionEdgeSmoothness = 0.05;
          panelPosition = "follow_bar";
          hideWallpaperFilenames = false;
          useOriginalImages = false;
          overviewBlur = 0.4;
          overviewTint = 0.6;
          useWallhaven = false;
          wallhavenQuery = "";
          wallhavenSorting = "relevance";
          wallhavenOrder = "desc";
          wallhavenCategories = "111";
          wallhavenPurity = "100";
          wallhavenRatios = "";
          wallhavenApiKey = "";
          wallhavenResolutionMode = "atleast";
          wallhavenResolutionWidth = "";
          wallhavenResolutionHeight = "";
          sortOrder = "name";
          favorites = [ ];
        };
        appLauncher = {
          enableClipboardHistory = false;
          autoPasteClipboard = false;
          enableClipPreview = true;
          clipboardWrapText = true;
          enableClipboardSmartIcons = true;
          enableClipboardChips = true;
          clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
          clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
          position = "center";
          pinnedApps = [ ];
          sortByMostUsed = true;
          terminalCommand = "alacritty -e";
          customLaunchPrefixEnabled = false;
          customLaunchPrefix = "";
          viewMode = "list";
          showCategories = true;
          iconMode = "tabler";
          showIconBackground = false;
          enableSettingsSearch = true;
          enableWindowsSearch = true;
          enableSessionSearch = true;
          ignoreMouseInput = false;
          screenshotAnnotationTool = "";
          overviewLayer = false;
          density = "default";
        };
        controlCenter = {
          position = "close_to_bar_button";
          diskPath = "/";
          shortcuts = {
            left = [
              { id = "Network"; }
              { id = "Bluetooth"; }
              { id = "WallpaperSelector"; }
              { id = "NoctaliaPerformance"; }
            ];
            right = [
              { id = "Notifications"; }
              { id = "PowerProfile"; }
              { id = "KeepAwake"; }
              { id = "NightLight"; }
            ];
          };
          cards = [
            { enabled = true; id = "profile-card"; }
            { enabled = true; id = "shortcuts-card"; }
            { enabled = true; id = "audio-card"; }
            { enabled = false; id = "brightness-card"; }
            { enabled = true; id = "weather-card"; }
            { enabled = true; id = "media-sysmon-card"; }
          ];
        };
        systemMonitor = {
          cpuWarningThreshold = 80;
          cpuCriticalThreshold = 90;
          tempWarningThreshold = 80;
          tempCriticalThreshold = 90;
          gpuWarningThreshold = 80;
          gpuCriticalThreshold = 90;
          memWarningThreshold = 80;
          memCriticalThreshold = 90;
          swapWarningThreshold = 80;
          swapCriticalThreshold = 90;
          diskWarningThreshold = 80;
          diskCriticalThreshold = 90;
          diskAvailWarningThreshold = 20;
          diskAvailCriticalThreshold = 10;
          batteryWarningThreshold = 20;
          batteryCriticalThreshold = 5;
          enableDgpuMonitoring = false;
          useCustomColors = false;
          warningColor = "";
          criticalColor = "";
          externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        };
        noctaliaPerformance = {
          disableWallpaper = true;
          disableDesktopWidgets = true;
        };
        dock = {
          enabled = true;
          position = "bottom";
          displayMode = "auto_hide";
          dockType = "attached";
          backgroundOpacity = 1;
          floatingRatio = 1;
          size = 1;
          onlySameOutput = true;
          monitors = [ ];
          pinnedApps = [ ];
          colorizeIcons = false;
          showLauncherIcon = false;
          launcherPosition = "end";
          launcherUseDistroLogo = false;
          launcherIcon = "";
          launcherIconColor = "none";
          pinnedStatic = false;
          inactiveIndicators = false;
          groupApps = false;
          groupContextMenuMode = "extended";
          groupClickAction = "cycle";
          groupIndicatorStyle = "dots";
          deadOpacity = 0.6;
          animationSpeed = 1;
          sitOnFrame = false;
          showDockIndicator = true;
          indicatorThickness = 3;
          indicatorColor = "primary";
          indicatorOpacity = 0.6;
        };
        network = {
          bluetoothRssiPollingEnabled = false;
          bluetoothRssiPollIntervalMs = 60000;
          networkPanelView = "wifi";
          wifiDetailsViewMode = "grid";
          bluetoothDetailsViewMode = "grid";
          bluetoothHideUnnamedDevices = false;
          disableDiscoverability = false;
          bluetoothAutoConnect = true;
        };
        sessionMenu = {
          enableCountdown = true;
          countdownDuration = 10000;
          position = "center";
          showHeader = true;
          showKeybinds = true;
          largeButtonsStyle = true;
          largeButtonsLayout = "single-row";
          powerOptions = [
            { action = "lock"; command = ""; countdownEnabled = true; enabled = true; keybind = "1"; }
            { action = "suspend"; command = ""; countdownEnabled = true; enabled = true; keybind = "2"; }
            { action = "hibernate"; command = ""; countdownEnabled = true; enabled = true; keybind = "3"; }
            { action = "reboot"; command = ""; countdownEnabled = true; enabled = true; keybind = "4"; }
            { action = "logout"; command = ""; countdownEnabled = true; enabled = true; keybind = "5"; }
            { action = "shutdown"; command = ""; countdownEnabled = true; enabled = true; keybind = "6"; }
            { action = "rebootToUefi"; command = ""; countdownEnabled = true; enabled = true; keybind = "7"; }
            { action = "userspaceReboot"; command = ""; countdownEnabled = true; enabled = false; keybind = ""; }
          ];
        };
        notifications = {
          enabled = true;
          enableMarkdown = false;
          density = "default";
          monitors = [ ];
          location = "top_right";
          overlayLayer = true;
          backgroundOpacity = 1;
          respectExpireTimeout = false;
          lowUrgencyDuration = 3;
          normalUrgencyDuration = 8;
          criticalUrgencyDuration = 15;
          clearDismissed = true;
          saveToHistory = {
            low = true;
            normal = true;
            critical = true;
          };
          sounds = {
            enabled = false;
            volume = 0.5;
            separateSounds = false;
            criticalSoundFile = "";
            normalSoundFile = "";
            lowSoundFile = "";
            excludedApps = "discord,firefox,chrome,chromium,edge";
          };
          enableMediaToast = false;
          enableKeyboardLayoutToast = true;
          enableBatteryToast = true;
        };
        osd = {
          enabled = true;
          location = "top_right";
          autoHideMs = 2000;
          overlayLayer = true;
          backgroundOpacity = 1;
          enabledTypes = [ 0 1 2 ];
          monitors = [ ];
        };
        audio = {
          volumeStep = 5;
          volumeOverdrive = false;
          spectrumFrameRate = 30;
          visualizerType = "linear";
          spectrumMirrored = true;
          mprisBlacklist = [ ];
          preferredPlayer = "";
          volumeFeedback = false;
          volumeFeedbackSoundFile = "";
        };
        brightness = {
          brightnessStep = 5;
          enforceMinimum = true;
          enableDdcSupport = false;
          backlightDeviceMappings = [ ];
        };
        colorSchemes = {
          useWallpaperColors = false;
          # Empty, not "Osaka jade": a non-empty predefinedScheme makes
          # noctalia regenerate colors.json from that preset on every
          # startup, silently overwriting the custom green/black scheme.
          predefinedScheme = "";
          darkMode = true;
          schedulingMode = "off";
          manualSunrise = "06:30";
          manualSunset = "18:30";
          generationMethod = "tonal-spot";
          monitorForColors = "";
          syncGsettings = true;
        };
        templates = {
          activeTemplates = [
            { enabled = true; id = "labwc"; }
            { enabled = true; id = "sway"; }
          ];
          enableUserTheming = false;
        };
        nightLight = {
          enabled = true;
          forced = false;
          autoSchedule = false;
          nightTemp = "4515";
          dayTemp = "6500";
          manualSunrise = "01:30";
          manualSunset = "01:30";
        };
        hooks = {
          enabled = false;
          wallpaperChange = "";
          darkModeChange = "";
          screenLock = "";
          screenUnlock = "";
          performanceModeEnabled = "";
          performanceModeDisabled = "";
          startup = "";
          session = "";
          colorGeneration = "";
        };
        plugins = {
          autoUpdate = false;
          notifyUpdates = true;
        };
        idle = {
          enabled = true;
          screenOffTimeout = 300;
          lockTimeout = 330;
          suspendTimeout = 1800;
          fadeDuration = 5;
          screenOffCommand = "";
          lockCommand = "";
          suspendCommand = "";
          resumeScreenOffCommand = "";
          resumeLockCommand = "";
          resumeSuspendCommand = "";
          customCommands = "[]";
        };
        desktopWidgets = {
          enabled = false;
          overviewEnabled = true;
          gridSnap = false;
          gridSnapScale = false;
          monitorWidgets = [ ];
        };
      };

      colors = {
        mError = "#FF4444";
        mHover = "#4AFF2E";
        mOnError = "#000000";
        mOnHover = "#000000";
        mOnPrimary = "#000000";
        mOnSecondary = "#000000";
        mOnSurface = "#E8FFE8";
        mOnSurfaceVariant = "#7FBF8F";
        mOnTertiary = "#000000";
        mOutline = "#1F4D2E";
        mPrimary = "#39FF14";
        mSecondary = "#22C55E";
        mShadow = "#000000";
        mSurface = "#000000";
        mSurfaceVariant = "#101810";
        mTertiary = "#86EFAC";
      };
    };
  };
}
