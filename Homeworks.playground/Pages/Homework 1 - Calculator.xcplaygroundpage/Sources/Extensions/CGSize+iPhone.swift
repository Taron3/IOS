import CoreGraphics

public extension CGSize {
    enum iPhone {
        public static var eight: CGSize         { return CGSize(width: 375, height: 667) }
        public static var eightPlus: CGSize     { return CGSize(width: 414, height: 736) }
        public static var xr: CGSize            { return CGSize(width: 414, height: 896) }
        public static var xs: CGSize            { return CGSize(width: 375, height: 812) }
        public static var xsMax: CGSize         { return CGSize(width: 414, height: 896) }
    }
}


