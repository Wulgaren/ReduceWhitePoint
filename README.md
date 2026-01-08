# Reduce White Point for macOS

A macOS menu bar app that reduces white point intensity, similar to iOS's "Reduce White Point" accessibility feature. This is specifically designed to reduce the intensity of bright colors and whites, which is different from brightness, color temperature, or dark mode adjustments.

## Features

- **White Point Reduction**: Specifically reduces the intensity of bright colors/whites
- **Menu Bar Control**: Easy access from the menu bar
- **Adjustable Intensity**: Slider to control reduction level (0-100%)
- **Persistent Settings**: Remembers your preferences
- **Independent Control**: Works alongside brightness, Night Shift, and dark mode

## How It Works

This app uses Core Graphics display transfer functions to adjust the gamma curve, which reduces the intensity of bright colors while maintaining relative color relationships. This is similar to how iOS implements white point reduction.

## Building

### Using Xcode

1. Open the project in Xcode:
   ```bash
   open Package.swift
   ```
2. Select your development team in Signing & Capabilities (if needed)
3. Select the ReduceWhitePoint scheme
4. Build and run (⌘R)

### Using Swift Package Manager

```bash
# Build in release mode
swift build -c release

# Run the app
swift run

# Or create an app bundle (requires additional setup)
```

**Note**: For a proper macOS app bundle, it's recommended to use Xcode, as it handles code signing and app packaging automatically.

## Usage

1. Build and launch the app
2. **First time**: macOS may prompt for accessibility permissions - grant them in System Settings → Privacy & Security → Accessibility
3. Click the menu bar icon (moon.stars)
4. Toggle "Enabled" to activate white point reduction
5. Adjust the intensity slider to your preference (0-100%)
6. Settings are automatically saved

**Note**: The app needs accessibility permissions to modify display settings. If the white point adjustment doesn't work, check System Settings → Privacy & Security → Accessibility and ensure the app is enabled.

## Technical Notes

- Uses `CGSetDisplayTransferByTable` to adjust display gamma
- Only affects the main display (can be extended for multiple displays)
- Requires macOS 13.0 or later
- Runs as a background app (no dock icon)

## Differences from Other Adjustments

- **Brightness**: Controls overall screen brightness (all colors equally)
- **Color Temperature** (Night Shift): Shifts colors towards warmer tones
- **Dark Mode**: Inverts UI colors
- **White Point Reduction**: Specifically reduces intensity of bright colors/whites (this app)

## License

MIT
