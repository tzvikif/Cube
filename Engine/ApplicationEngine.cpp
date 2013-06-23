//
//  ApplicationEngine.cpp
//  cube
//
//  Created by tzviki fisher on 14/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <iostream>
#include "ApplicatonEngine.hpp"

ApplicationEngine::ApplicationEngine()
{
    m_scaleFactor = 1;
}
void ApplicationEngine::OnFingerUp(ivec2 location)
{
    
}

void ApplicationEngine::OnFingerDown(ivec2 location)
{
    
}

void ApplicationEngine::OnFingerMove(ivec2 oldLocation, ivec2 location)
{
    
}
void ApplicationEngine::OnPinch(float factor)
{
    m_scaleFactor = factor;
}

vec3 ApplicationEngine::MapToSphere(ivec2 touchpoint) const
{
    vec2 p = touchpoint - m_centerPoint;
    
    // Flip the Y axis because pixel coords increase towards the bottom.
    p.y = -p.y;
    
    const float radius = m_trackballRadius;
    const float safeRadius = radius - 1;
    
    if (p.Length() > safeRadius) {
        float theta = atan2(p.y, p.x);
        p.x = safeRadius * cos(theta);
        p.y = safeRadius * sin(theta);
    }
    
    float z = sqrt(radius * radius - p.LengthSquared());
    vec3 mapped = vec3(p.x, p.y, z);
    return mapped / radius;
}
void ApplicationEngine::Render() const
{
    
}