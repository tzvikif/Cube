//
//  GLView.h
//  cube
//
//  Created by tzviki fisher on 02/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>
#include "ApplicatonEngine.hpp"
#import "LoadObj.h"


@interface GLView : UIView
{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    
    GLuint _colorRenderBuffer;
    GLuint _depthRenderBuffer;
//    GLuint _positionSlot;
//    GLuint _colorSlot;
//    GLuint _projectionUniform;
//    GLuint _modelViewUniform;
//    
//    GLuint _vertexBuffer;
//    GLuint _indexBuffer;
//    float _currentRotataion;
//    ApplicationEngine *ap;
//    float m_factor;
//    GLint _uniform_fade;
//    CFTimeInterval _timeSinceLastUpdate;
//    CFTimeInterval _timeRotation;
//    float _rotationAngle;
//    GLuint vbo_cube_vertices, vbo_cube_colors, vbo_cube_texcoords;
//    GLuint ibo_cube_elements;
//    GLuint _texture_id;
//    GLint _uniform_mytexture;
//    GLint _attribute_texcoord;
}
+ (Class)layerClass;
- (void)setupLayer;
- (void)setupContext;
- (void)setupRenderBuffer;
- (void)setupFrameBuffer;
//- (void)render:(CADisplayLink*)displayLink;
//- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType;
//- (void)compileShaders;
//- (void)setupVBOs;
//- (void)setupDisplayLink;
//- (void)setupDepthBuffer;
//- (void)handlePinchGesture:(UIGestureRecognizer *)sender;
//- (void)createGestureRecognizers;
//- (void)update:(CADisplayLink*)displayLink;
//- (GLuint)setupTexture:(NSString *)fileName;
//- (void)setupTextures;
//- (void)initResources;
//- (void)loadObj;
- (void)presentRenderbuffer;
//-(void)UpdateAnimation:(float)dt;
@property(retain,nonatomic) LoadObj *objLoader;
@end
