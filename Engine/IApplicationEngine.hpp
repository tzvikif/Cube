//
//  IApplicationEngine.hpp
//  cube
//
//  Created by tzviki fisher on 14/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef cube_IApplicationEngine_hpp
#define cube_IApplicationEngine_hpp

#pragma once
#include <vector>
#include <string>
#include "Vector.hpp"
#include "Quaternion.hpp"

struct Visual {
    vec3 Color;
    ivec2 LowerLeft;
    ivec2 ViewportSize;
    Quaternion Orientation;
};

struct IApplicationEngine {
    virtual void Initialize(int width, int height) = 0;
    virtual void Render() const = 0;
    virtual void UpdateAnimation(float timeStep) = 0;
    virtual void OnFingerUp(ivec2 location) = 0;
    virtual void OnFingerDown(ivec2 location) = 0;
    virtual void OnFingerMove(ivec2 oldLocation, ivec2 newLocation) = 0;
    //virtual void OnPinch(float factor) = 0;
    virtual ~IApplicationEngine() {}
};


#endif
