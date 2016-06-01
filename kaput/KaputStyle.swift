//
//  KaputStyle.swift
//  KAPUT
//
//  Created by KAPUT on 01/06/2016.
//  Copyright (c) 2016 OPE50. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import UIKit

public class KaputStyle : NSObject {

    //// Cache

    private struct Cache {
        static let lowRed: UIColor = UIColor(red: 0.986, green: 0.101, blue: 0.309, alpha: 1.000)
        static let chargingBlue: UIColor = UIColor(red: 0.165, green: 0.433, blue: 0.984, alpha: 1.000)
        static let shadowColor: UIColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.200)
        static let fullGreen: UIColor = UIColor(red: 0.115, green: 0.881, blue: 0.396, alpha: 1.000)
        static let shadow: NSShadow = NSShadow(color: KaputStyle.shadowColor, offset: CGSize(width: 10.1, height: 10.1), blurRadius: 0)
    }

    //// Colors

    public class var lowRed: UIColor { return Cache.lowRed }
    public class var chargingBlue: UIColor { return Cache.chargingBlue }
    public class var shadowColor: UIColor { return Cache.shadowColor }
    public class var fullGreen: UIColor { return Cache.fullGreen }

    //// Shadows

    public class var shadow: NSShadow { return Cache.shadow }

    //// Drawing Methods

    public class func drawLogoKaput() {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Color Declarations
        let strokeColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let fillColor3 = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        let fillColor4 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)

        //// Screens
        //// Home-Screen-Red
        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, KaputStyle.shadow.shadowOffset, KaputStyle.shadow.shadowBlurRadius, (KaputStyle.shadow.shadowColor as! UIColor).CGColor)
        CGContextBeginTransparencyLayer(context, nil)


        //// LOGO
        //// path-1 Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 86.05, 48.65)
        CGContextRotateCTM(context, -3 * CGFloat(M_PI) / 180)


        CGContextRestoreGState(context)


        //// path- Drawing
        let pathPath = UIBezierPath()
        pathPath.moveToPoint(CGPoint(x: 10.75, y: 88.35))
        pathPath.addLineToPoint(CGPoint(x: 165.09, y: 80.26))
        pathPath.addLineToPoint(CGPoint(x: 161.35, y: 8.95))
        pathPath.addLineToPoint(CGPoint(x: 7.01, y: 17.04))
        pathPath.addLineToPoint(CGPoint(x: 10.75, y: 88.35))
        pathPath.closePath()
        fillColor3.setFill()
        pathPath.fill()
        strokeColor.setStroke()
        pathPath.lineWidth = 7
        pathPath.stroke()


        //// path-3 Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 32.5, 51.3)
        CGContextRotateCTM(context, -3 * CGFloat(M_PI) / 180)


        CGContextRestoreGState(context)


        //// path- 2 Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 32.5, 51.3)
        CGContextRotateCTM(context, -3 * CGFloat(M_PI) / 180)

        let path2Path = UIBezierPath(rect: CGRect(x: -12.2, y: -24.7, width: 24.4, height: 49.4))
        KaputStyle.lowRed.setFill()
        path2Path.fill()

        CGContextRestoreGState(context)


        //// KAPUT Drawing
        let kAPUTPath = UIBezierPath()
        kAPUTPath.moveToPoint(CGPoint(x: 48.97, y: 69.85))
        kAPUTPath.addLineToPoint(CGPoint(x: 41.23, y: 70.26))
        kAPUTPath.addLineToPoint(CGPoint(x: 36.16, y: 50.2))
        kAPUTPath.addLineToPoint(CGPoint(x: 36.05, y: 50.2))
        kAPUTPath.addLineToPoint(CGPoint(x: 33.9, y: 70.64))
        kAPUTPath.addLineToPoint(CGPoint(x: 26.03, y: 71.06))
        kAPUTPath.addLineToPoint(CGPoint(x: 30.23, y: 30.92))
        kAPUTPath.addLineToPoint(CGPoint(x: 38.09, y: 30.51))
        kAPUTPath.addLineToPoint(CGPoint(x: 36.23, y: 48.44))
        kAPUTPath.addLineToPoint(CGPoint(x: 36.33, y: 48.44))
        kAPUTPath.addLineToPoint(CGPoint(x: 44.74, y: 30.16))
        kAPUTPath.addLineToPoint(CGPoint(x: 52.77, y: 29.74))
        kAPUTPath.addLineToPoint(CGPoint(x: 43.49, y: 48.65))
        kAPUTPath.addLineToPoint(CGPoint(x: 49.02, y: 68.06))
        kAPUTPath.addLineToPoint(CGPoint(x: 61.85, y: 29.26))
        kAPUTPath.addLineToPoint(CGPoint(x: 70.14, y: 28.83))
        kAPUTPath.addLineToPoint(CGPoint(x: 75.5, y: 68.46))
        kAPUTPath.addLineToPoint(CGPoint(x: 67.11, y: 68.9))
        kAPUTPath.addLineToPoint(CGPoint(x: 66.33, y: 62.22))
        kAPUTPath.addLineToPoint(CGPoint(x: 58.36, y: 62.64))
        kAPUTPath.addLineToPoint(CGPoint(x: 56.23, y: 69.47))
        kAPUTPath.addLineToPoint(CGPoint(x: 48.97, y: 69.85))
        kAPUTPath.closePath()
        kAPUTPath.moveToPoint(CGPoint(x: 65.85, y: 56))
        kAPUTPath.addLineToPoint(CGPoint(x: 60.3, y: 56.29))
        kAPUTPath.addLineToPoint(CGPoint(x: 63.13, y: 45.5))
        kAPUTPath.addLineToPoint(CGPoint(x: 64.61, y: 39.39))
        kAPUTPath.addLineToPoint(CGPoint(x: 64.71, y: 39.38))
        kAPUTPath.addLineToPoint(CGPoint(x: 64.97, y: 45.4))
        kAPUTPath.addLineToPoint(CGPoint(x: 65.85, y: 56))
        kAPUTPath.closePath()
        kAPUTPath.moveToPoint(CGPoint(x: 84.21, y: 68.01))
        kAPUTPath.addLineToPoint(CGPoint(x: 85.94, y: 51.45))
        kAPUTPath.addLineToPoint(CGPoint(x: 87.69, y: 51.47))
        kAPUTPath.addCurveToPoint(CGPoint(x: 96.84, y: 47.86), controlPoint1: CGPoint(x: 91.38, y: 51.27), controlPoint2: CGPoint(x: 94.43, y: 50.07))
        kAPUTPath.addCurveToPoint(CGPoint(x: 101.01, y: 39.01), controlPoint1: CGPoint(x: 99.25, y: 45.65), controlPoint2: CGPoint(x: 100.64, y: 42.7))
        kAPUTPath.addCurveToPoint(CGPoint(x: 101.13, y: 36.25), controlPoint1: CGPoint(x: 101.13, y: 38.02), controlPoint2: CGPoint(x: 101.17, y: 37.1))
        kAPUTPath.addCurveToPoint(CGPoint(x: 99.72, y: 31.48), controlPoint1: CGPoint(x: 101.03, y: 34.28), controlPoint2: CGPoint(x: 100.56, y: 32.69))
        kAPUTPath.addCurveToPoint(CGPoint(x: 96.61, y: 28.89), controlPoint1: CGPoint(x: 98.88, y: 30.28), controlPoint2: CGPoint(x: 97.84, y: 29.41))
        kAPUTPath.addCurveToPoint(CGPoint(x: 92.83, y: 27.93), controlPoint1: CGPoint(x: 95.39, y: 28.38), controlPoint2: CGPoint(x: 94.13, y: 28.05))
        kAPUTPath.addCurveToPoint(CGPoint(x: 88.72, y: 27.85), controlPoint1: CGPoint(x: 91.54, y: 27.8), controlPoint2: CGPoint(x: 90.17, y: 27.78))
        kAPUTPath.addLineToPoint(CGPoint(x: 80.54, y: 28.28))
        kAPUTPath.addLineToPoint(CGPoint(x: 76.35, y: 68.42))
        kAPUTPath.addLineToPoint(CGPoint(x: 84.21, y: 68.01))
        kAPUTPath.closePath()
        kAPUTPath.moveToPoint(CGPoint(x: 87.75, y: 34.42))
        kAPUTPath.addLineToPoint(CGPoint(x: 89.22, y: 34.34))
        kAPUTPath.addCurveToPoint(CGPoint(x: 92.18, y: 35.19), controlPoint1: CGPoint(x: 90.56, y: 34.27), controlPoint2: CGPoint(x: 91.55, y: 34.55))
        kAPUTPath.addCurveToPoint(CGPoint(x: 93.22, y: 37.89), controlPoint1: CGPoint(x: 92.81, y: 35.83), controlPoint2: CGPoint(x: 93.16, y: 36.73))
        kAPUTPath.addCurveToPoint(CGPoint(x: 93.14, y: 39.32), controlPoint1: CGPoint(x: 93.25, y: 38.34), controlPoint2: CGPoint(x: 93.22, y: 38.82))
        kAPUTPath.addCurveToPoint(CGPoint(x: 91.29, y: 43.52), controlPoint1: CGPoint(x: 92.96, y: 41.24), controlPoint2: CGPoint(x: 92.34, y: 42.64))
        kAPUTPath.addCurveToPoint(CGPoint(x: 86.61, y: 45.01), controlPoint1: CGPoint(x: 90.25, y: 44.4), controlPoint2: CGPoint(x: 88.68, y: 44.9))
        kAPUTPath.addLineToPoint(CGPoint(x: 87.75, y: 34.42))
        kAPUTPath.closePath()
        kAPUTPath.moveToPoint(CGPoint(x: 103.72, y: 27.07))
        kAPUTPath.addLineToPoint(CGPoint(x: 100.62, y: 56.88))
        kAPUTPath.addCurveToPoint(CGPoint(x: 100.54, y: 59.37), controlPoint1: CGPoint(x: 100.53, y: 57.76), controlPoint2: CGPoint(x: 100.5, y: 58.59))
        kAPUTPath.addCurveToPoint(CGPoint(x: 103.51, y: 65.54), controlPoint1: CGPoint(x: 100.69, y: 62.18), controlPoint2: CGPoint(x: 101.68, y: 64.24))
        kAPUTPath.addCurveToPoint(CGPoint(x: 111.17, y: 67.23), controlPoint1: CGPoint(x: 105.35, y: 66.84), controlPoint2: CGPoint(x: 107.9, y: 67.4))
        kAPUTPath.addCurveToPoint(CGPoint(x: 117.74, y: 65.77), controlPoint1: CGPoint(x: 113.85, y: 67.09), controlPoint2: CGPoint(x: 116.04, y: 66.6))
        kAPUTPath.addCurveToPoint(CGPoint(x: 121.63, y: 62.74), controlPoint1: CGPoint(x: 119.44, y: 64.94), controlPoint2: CGPoint(x: 120.74, y: 63.93))
        kAPUTPath.addCurveToPoint(CGPoint(x: 123.48, y: 59.09), controlPoint1: CGPoint(x: 122.52, y: 61.54), controlPoint2: CGPoint(x: 123.14, y: 60.33))
        kAPUTPath.addCurveToPoint(CGPoint(x: 124.2, y: 55.11), controlPoint1: CGPoint(x: 123.82, y: 57.86), controlPoint2: CGPoint(x: 124.06, y: 56.53))
        kAPUTPath.addLineToPoint(CGPoint(x: 127.27, y: 25.83))
        kAPUTPath.addLineToPoint(CGPoint(x: 119.4, y: 26.24))
        kAPUTPath.addLineToPoint(CGPoint(x: 116.51, y: 53.93))
        kAPUTPath.addLineToPoint(CGPoint(x: 116.52, y: 54.03))
        kAPUTPath.addCurveToPoint(CGPoint(x: 116.14, y: 56.43), controlPoint1: CGPoint(x: 116.39, y: 55.03), controlPoint2: CGPoint(x: 116.27, y: 55.83))
        kAPUTPath.addCurveToPoint(CGPoint(x: 115.49, y: 58.16), controlPoint1: CGPoint(x: 116.01, y: 57.04), controlPoint2: CGPoint(x: 115.79, y: 57.62))
        kAPUTPath.addCurveToPoint(CGPoint(x: 114.18, y: 59.47), controlPoint1: CGPoint(x: 115.18, y: 58.71), controlPoint2: CGPoint(x: 114.74, y: 59.14))
        kAPUTPath.addCurveToPoint(CGPoint(x: 112.01, y: 60.04), controlPoint1: CGPoint(x: 113.61, y: 59.8), controlPoint2: CGPoint(x: 112.89, y: 59.99))
        kAPUTPath.addCurveToPoint(CGPoint(x: 109.45, y: 59.22), controlPoint1: CGPoint(x: 110.82, y: 60.1), controlPoint2: CGPoint(x: 109.96, y: 59.83))
        kAPUTPath.addCurveToPoint(CGPoint(x: 108.6, y: 56.62), controlPoint1: CGPoint(x: 108.95, y: 58.61), controlPoint2: CGPoint(x: 108.66, y: 57.74))
        kAPUTPath.addCurveToPoint(CGPoint(x: 108.8, y: 53.32), controlPoint1: CGPoint(x: 108.57, y: 55.91), controlPoint2: CGPoint(x: 108.63, y: 54.81))
        kAPUTPath.addLineToPoint(CGPoint(x: 108.87, y: 52.63))
        kAPUTPath.addLineToPoint(CGPoint(x: 111.59, y: 26.65))
        kAPUTPath.addLineToPoint(CGPoint(x: 103.72, y: 27.07))
        kAPUTPath.closePath()
        kAPUTPath.moveToPoint(CGPoint(x: 128.32, y: 25.78))
        kAPUTPath.addLineToPoint(CGPoint(x: 127.55, y: 33.23))
        kAPUTPath.addLineToPoint(CGPoint(x: 133.73, y: 32.91))
        kAPUTPath.addLineToPoint(CGPoint(x: 130.3, y: 65.59))
        kAPUTPath.addLineToPoint(CGPoint(x: 138.17, y: 65.18))
        kAPUTPath.addLineToPoint(CGPoint(x: 141.59, y: 32.49))
        kAPUTPath.addLineToPoint(CGPoint(x: 147.82, y: 32.17))
        kAPUTPath.addLineToPoint(CGPoint(x: 148.6, y: 24.71))
        kAPUTPath.addLineToPoint(CGPoint(x: 128.32, y: 25.78))
        kAPUTPath.closePath()
        kAPUTPath.miterLimit = 4;

        kAPUTPath.usesEvenOddFillRule = true;

        fillColor4.setFill()
        kAPUTPath.fill()


        //// Rectangle-59 Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 167.35, 44.45)
        CGContextRotateCTM(context, -3 * CGFloat(M_PI) / 180)

        let rectangle59Path = UIBezierPath(rect: CGRect(x: -5.03, y: -12.3, width: 10.05, height: 24.6))
        fillColor4.setFill()
        rectangle59Path.fill()

        CGContextRestoreGState(context)




        CGContextEndTransparencyLayer(context)
        CGContextRestoreGState(context)
    }

    public class func drawBatteryNotificationCanvas() {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Color Declarations
        let strokeColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let textForeground = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let fillColor3 = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        let fillColor4 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)

        //// Screens
        //// Notif
        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, KaputStyle.shadow.shadowOffset, KaputStyle.shadow.shadowBlurRadius, (KaputStyle.shadow.shadowColor as! UIColor).CGColor)
        CGContextBeginTransparencyLayer(context, nil)


        //// batteryNotification
        //// battery
        //// batteryContainer
        //// batteryBlack
        //// path-1 Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 168.65, 63.9)
        CGContextRotateCTM(context, -3 * CGFloat(M_PI) / 180)


        CGContextRestoreGState(context)


        //// path- Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 168.65, 63.9)
        CGContextRotateCTM(context, -3 * CGFloat(M_PI) / 180)

        let pathPath = UIBezierPath(rect: CGRect(x: -165.4, y: -48.08, width: 330.8, height: 96.15))
        fillColor3.setFill()
        pathPath.fill()
        strokeColor.setStroke()
        pathPath.lineWidth = 5
        pathPath.stroke()

        CGContextRestoreGState(context)


        //// level Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 54.35, 69.9)
        CGContextRotateCTM(context, -3 * CGFloat(M_PI) / 180)

        let levelPath = UIBezierPath(rect: CGRect(x: -44.05, y: -41.3, width: 88.1, height: 82.6))
        KaputStyle.lowRed.setFill()
        levelPath.fill()

        CGContextRestoreGState(context)


        //// Label Drawing
        let labelRect = CGRect(x: 31.73, y: 35.23, width: 304.1, height: 69)
        let labelStyle = NSMutableParagraphStyle()
        labelStyle.alignment = .Left

        let labelFontAttributes = [NSFontAttributeName: UIFont(name: "Futura-CondensedBoldOblique", size: 54.17)!, NSForegroundColorAttributeName: textForeground, NSParagraphStyleAttributeName: labelStyle]

        "ANDREA IS 3%".drawInRect(labelRect, withAttributes: labelFontAttributes)






        //// batteryCap Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 336.75, 56.25)
        CGContextRotateCTM(context, -3 * CGFloat(M_PI) / 180)

        let batteryCapPath = UIBezierPath(rect: CGRect(x: -5.15, y: -12.6, width: 10.3, height: 25.2))
        fillColor4.setFill()
        batteryCapPath.fill()

        CGContextRestoreGState(context)




        //// timeLabelBackground Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 171.45, 16.35)
        CGContextRotateCTM(context, -3 * CGFloat(M_PI) / 180)

        let timeLabelBackgroundPath = UIBezierPath(rect: CGRect(x: -46, y: -13.5, width: 92, height: 27))
        KaputStyle.chargingBlue.setFill()
        timeLabelBackgroundPath.fill()

        CGContextRestoreGState(context)


        //// Label 2 Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 130.09, 5.74)
        CGContextRotateCTM(context, -3 * CGFloat(M_PI) / 180)

        let label2Rect = CGRect(x: 0, y: 0, width: 87.31, height: 26)
        let label2Style = NSMutableParagraphStyle()
        label2Style.alignment = .Left

        let label2FontAttributes = [NSFontAttributeName: UIFont(name: "Futura-CondensedBoldOblique", size: 20)!, NSForegroundColorAttributeName: textForeground, NSParagraphStyleAttributeName: label2Style]

        "3 MN AGO".drawInRect(label2Rect, withAttributes: label2FontAttributes)

        CGContextRestoreGState(context)




        CGContextEndTransparencyLayer(context)
        CGContextRestoreGState(context)
    }

    public class func drawCheckSignCanvas() {
        //// Color Declarations
        let strokeColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let fillColor4 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)

        //// Screens
        //// Add-Friends
        //// checkSign
        //// Rectangle-129-Copy-2 Drawing
        let rectangle129Copy2Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 43, height: 43))
        KaputStyle.fullGreen.setFill()
        rectangle129Copy2Path.fill()
        strokeColor.setStroke()
        rectangle129Copy2Path.lineWidth = 4
        rectangle129Copy2Path.stroke()


        //// Check Drawing
        let checkPath = UIBezierPath()
        checkPath.moveToPoint(CGPoint(x: 14.96, y: 20.85))
        checkPath.addLineToPoint(CGPoint(x: 13, y: 22.8))
        checkPath.addLineToPoint(CGPoint(x: 18.23, y: 28))
        checkPath.addLineToPoint(CGPoint(x: 30, y: 16.95))
        checkPath.addLineToPoint(CGPoint(x: 28.04, y: 15))
        checkPath.addLineToPoint(CGPoint(x: 18.23, y: 24.1))
        checkPath.addLineToPoint(CGPoint(x: 14.96, y: 20.85))
        checkPath.closePath()
        checkPath.miterLimit = 4;

        checkPath.usesEvenOddFillRule = true;

        fillColor4.setFill()
        checkPath.fill()
    }

    public class func drawBackArrow() {
        //// Color Declarations
        let fillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)

        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 14.79, y: 29.49))
        bezierPath.addLineToPoint(CGPoint(x: 0.05, y: 15))
        bezierPath.addLineToPoint(CGPoint(x: 14.79, y: 0.51))
        bezierPath.addLineToPoint(CGPoint(x: 16.79, y: 2.49))
        bezierPath.addLineToPoint(CGPoint(x: 4.06, y: 15))
        bezierPath.addLineToPoint(CGPoint(x: 16.79, y: 27.51))
        bezierPath.addLineToPoint(CGPoint(x: 14.79, y: 29.49))
        bezierPath.closePath()
        bezierPath.usesEvenOddFillRule = true;

        fillColor.setFill()
        bezierPath.fill()


        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRect(x: 2.07, y: 13.5, width: 25.95, height: 3))
        fillColor.setFill()
        rectanglePath.fill()
    }

}



extension NSShadow {
    convenience init(color: AnyObject!, offset: CGSize, blurRadius: CGFloat) {
        self.init()
        self.shadowColor = color
        self.shadowOffset = offset
        self.shadowBlurRadius = blurRadius
    }
}
