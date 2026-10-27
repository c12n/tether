// Draws the 1024 px app icon: two linked rings on a blue to teal gradient.
// Run: swift scripts/make-icon.swift Sources/Assets.xcassets/AppIcon.appiconset/icon-1024.png
import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

let size = 1024
let space = CGColorSpace(name: CGColorSpace.sRGB)!
let ctx = CGContext(data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: 0,
                    space: space, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
let s = CGFloat(size)

let gradient = CGGradient(colorsSpace: space, colors: [
    CGColor(srgbRed: 0.10, green: 0.36, blue: 0.95, alpha: 1),
    CGColor(srgbRed: 0.05, green: 0.78, blue: 0.76, alpha: 1),
] as CFArray, locations: [0, 1])!
ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: s), end: CGPoint(x: s, y: 0), options: [])

// Two rounded links, tilted 45 degrees and overlapping like a chain.
ctx.translateBy(x: s / 2, y: s / 2)
ctx.rotate(by: .pi / 4)
let linkW = s * 0.46, linkH = s * 0.24, offset = s * 0.17, line = s * 0.07
ctx.setStrokeColor(CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1))
ctx.setLineWidth(line)
for dx in [-offset, offset] {
    let r = CGRect(x: dx - linkW / 2, y: -linkH / 2, width: linkW, height: linkH)
    ctx.addPath(CGPath(roundedRect: r, cornerWidth: linkH / 2, cornerHeight: linkH / 2, transform: nil))
    ctx.strokePath()
}

let url = URL(fileURLWithPath: CommandLine.arguments[1])
let dest = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(dest, ctx.makeImage()!, nil)
CGImageDestinationFinalize(dest)
print("wrote", url.path)
