//
//  TYFoundationKitMacro.h
//  TYFoundationKit
//
//  Created by TuyaInc on 2019/3/26.
//

#ifndef TYFoundationKitMacro_h
#define TYFoundationKitMacro_h

#ifndef ty_weakify
    #define ty_weakify(object)  __weak __typeof__(object) weak##_##object = object;
#endif

#ifndef ty_strongify
    #define ty_strongify(object)  __typeof__(object) object = weak##_##object;
#endif

#ifndef TY_StringFromSEL
    #define TY_StringFromSEL(name) NSStringFromSelector(@selector(name))
#endif

inline CGFloat TY_CelsiusToFahrenheit(CGFloat c) {
    return c * 1.8 + 32;
}
inline CGFloat TY_FahrenheitToCelsius(CGFloat f) {
    return (f - 32) / 1.8;
}

#endif /* TYFoundationKitMacro_h */
