//
//  GLViewController.h
//  cube
//
//  Created by tzvifi on 7/17/13.
//
//

#import <UIKit/UIKit.h>
@class LoadObj;
struct UniformHandles {
    GLuint Modelview;
    GLuint Projection;
    GLuint NormalMatrix;
    GLuint LightPosition;
    GLuint Texture;
    GLint Ambient;
    GLint Diffuse;
    GLint Specular;
    GLint Shininess;
};
struct AttributeHandles {
    GLint Position;
    GLint Normal;
    GLint Texcoord;
    GLint Color;
};
@interface GLViewController : UIViewController {
    GLfloat _currentRotationAngle;
}
@property(nonatomic,assign) UniformHandles uHandles;
@property(nonatomic,assign) AttributeHandles aHandles;
@property(nonatomic,assign) GLuint texture_id;
@property(nonatomic,assign) GLuint programHandle;
@property(nonatomic,assign) GLfloat *normals;
//@property(nonatomic,assign) GLuint positionSlot,
//                                    colorSlot,
//                                    texture_id,
//                                    normalSlot,
//                                    attribute_texcoord;
//@property(nonatomic,assign) GLuint modelViewUniform,
//                                    projectionUniform,
//                                    uniform_mytexture,
//                                    lightDirectionUniform;
@property(nonatomic,assign) GLuint vbo_cube_vertices,
                                    vbo_cube_colors,
                                    ibo_cube_elements,
                                    vbo_cube_texcoords,
                                    vbo_cube_normals;
@property(nonatomic,retain) LoadObj *objLoader;
@property(nonatomic,assign) float rotationAngle;
@property(nonatomic,assign)  CFTimeInterval timeSinceLastUpdate;
@property(nonatomic,assign) CFTimeInterval timeRotation;

-(void)loadObj;
-(void)initResources;
- (GLuint)setupTexture:(NSString *)fileName;
-(void)setupTextures;
- (void)setupVBOs;
- (void)setupDisplayLink;
- (void)render:(CADisplayLink*)displayLink;
- (void)update:(CADisplayLink*)displayLink;
- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType;
- (void)compileShaders;
- (void)checkAttribute:(GLuint)attribute name:(const char*)name;
- (void)computeNormals;
@end