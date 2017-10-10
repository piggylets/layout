//  Copyright © 2017 Schibsted. All rights reserved.

import QuartzCore

private var _cachedExpressionTypes = [Int: [String: RuntimeType]]()

extension CALayer {
    /// Expression names and types
    @objc class var expressionTypes: [String: RuntimeType] {
        var types = allPropertyTypes()
        types["contents"] = RuntimeType(CGImage.self)
        for key in [
            "borderWidth",
            "contentsScale",
            "cornerRadius",
            "shadowRadius",
            "rasterizationScale",
            "zPosition",
        ] {
            types[key] = RuntimeType(CGFloat.self)
        }
        types["contentsGravity"] = RuntimeType([
            "center",
            "top",
            "bottom",
            "left",
            "right",
            "topLeft",
            "topRight",
            "bottomLeft",
            "bottomRight",
            "resize",
            "resizeAspect",
            "resizeAspectFill",
        ] as Set<String>)
        types["edgeAntialiasingMask"] = RuntimeType([
            "layerLeftEdge": .layerLeftEdge,
            "layerRightEdge": .layerRightEdge,
            "layerBottomEdge": .layerBottomEdge,
            "layerTopEdge": .layerTopEdge,
        ] as [String: CAEdgeAntialiasingMask])
        types["fillMode"] = RuntimeType([
            "backwards",
            "forwards",
            "both",
            "removed",
        ] as Set<String>)
        types["minificationFilter"] = RuntimeType([
            "nearest",
            "linear",
        ] as Set<String>)
        types["magnificationFilter"] = RuntimeType([
            "nearest",
            "linear",
        ] as Set<String>)
        types["maskedCorners"] = RuntimeType([
            "layerMinXMinYCorner": UIntOptionSet(rawValue: 1),
            "layerMaxXMinYCorner": UIntOptionSet(rawValue: 2),
            "layerMinXMaxYCorner": UIntOptionSet(rawValue: 4),
            "layerMaxXMaxYCorner": UIntOptionSet(rawValue: 8),
        ] as [String: UIntOptionSet])
        #if swift(>=3.2)
            if #available(iOS 11.0, *) {
                types["maskedCorners"] = RuntimeType([
                    "layerMinXMinYCorner": .layerMinXMinYCorner,
                    "layerMaxXMinYCorner": .layerMaxXMinYCorner,
                    "layerMinXMaxYCorner": .layerMinXMaxYCorner,
                    "layerMaxXMaxYCorner": .layerMaxXMaxYCorner,
                ] as [String: CACornerMask])
            }
        #endif
        // Explicitly disabled properties
        for name in [
            "bounds",
            "frame",
            "position",
        ] {
            types[name] = .unavailable("Use top/left/width/height expressions instead")
            let name = "\(name)."
            for key in types.keys where key.hasPrefix(name) {
                types[key] = .unavailable("Use top/left/width/height expressions instead")
            }
        }
        for name in [
            "anchorPoint",
            "needsDisplayInRect",
        ] {
            types[name] = .unavailable()
            for key in types.keys where key.hasPrefix(name) {
                types[key] = .unavailable()
            }
        }

        #if arch(i386) || arch(x86_64)
            // Private properties
            for name in [
                "acceleratesDrawing",
                "allowsContentsRectCornerMasking",
                "allowsDisplayCompositing",
                "allowsGroupBlending",
                "allowsHitTesting",
                "backgroundColorPhase",
                "behaviors",
                "canDrawConcurrently",
                "clearsContext",
                "coefficientOfRestitution",
                "contentsContainsSubtitles",
                "contentsDither",
                "contentsMultiplyByColor",
                "contentsOpaque",
                "contentsScaling",
                "continuousCorners",
                "cornerContentsCenter",
                "cornerContentsMaskEdges",
                "doubleBounds",
                "doublePosition",
                "flipsHorizontalAxis",
                "hitTestsAsOpaque",
                "inheritsTiming",
                "invertsShadow",
                "isFlipped",
                "isFrozen",
                "literalContentsCenter",
                "mass",
                "meshTransform",
                "momentOfInertia",
                "motionBlurAmount",
                "needsLayoutOnGeometryChange",
                "perspectiveDistance",
                "preloadsCache",
                "presentationModifiers",
                "rasterizationPrefersDisplayCompositing",
                "sizeRequisition",
                "sortsSublayers",
                "stateTransitions",
                "states",
                "velocityStretch",
                "wantsExtendedDynamicRangeContent",
            ] {
                types[name] = nil
                for key in types.keys where key.hasPrefix(name) {
                    types[key] = nil
                }
            }
        #endif
        return types
    }

    class var cachedExpressionTypes: [String: RuntimeType] {
        if let types = _cachedExpressionTypes[self.hash()] {
            return types
        }
        let types = expressionTypes
        _cachedExpressionTypes[self.hash()] = types
        return types
    }
}
