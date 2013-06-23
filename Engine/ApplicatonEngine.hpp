//
//  ApplicatonEngine.hpp
//  cube
//
//  Created by tzviki fisher on 14/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef cube_ApplicatonEngine_hpp
#define cube_ApplicatonEngine_hpp
#include "IApplicationEngine.hpp"
#include "Quaternion.hpp"

class ApplicationEngine : public IApplicationEngine {
public:
    void OnFingerUp(ivec2 location);
    void OnFingerDown(ivec2 location);
    void OnFingerMove(ivec2 oldLocation, ivec2 newLocation);
    void OnPinch(float factor);
    void Render() const;
    ApplicationEngine();

private:

    vec3 MapToSphere(ivec2 touchpoint) const;
    float m_trackballRadius;
    ivec2 m_screenSize;
    ivec2 m_centerPoint;
    ivec2 m_fingerStart;
    Quaternion m_orientation;
    Quaternion m_previousOrientation;
    Matrix4<float> m_modelView;
    float m_scaleFactor;
};


#endif
