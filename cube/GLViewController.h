//
//  GLViewController.h
//  cube
//
//  Created by tzvifi on 7/17/13.
//
//

#import <UIKit/UIKit.h>
@class LoadObj;
@class CC3GLMatrix;
struct UniformHandles {
    GLuint Model;
    GLuint View;
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
   
}
@property(nonatomic,assign) UniformHandles uHandles;
@property(nonatomic,assign) AttributeHandles aHandles;
@property(nonatomic,assign) GLuint texture_id;
@property(nonatomic,assign) GLuint programHandle;
@property(nonatomic,assign) GLfloat *normals;
@property(nonatomic,assign) GLuint prevX,prevY,currX,currY;
//@property(nonatomic,assign) GLfloat *matModelToWord,*matWorldToEye;
@property(nonatomic,assign) GLfloat currentRotationAngle,anchorAngle,deltaAngle;
@property(nonatomic,assign) BOOL isMoving;
@property(nonatomic,assign) GLuint vbo_cube_vertices,
                                    vbo_cube_colors,
                                    ibo_cube_elements,
                                    vbo_cube_texcoords,
                                    vbo_cube_normals;
@property(nonatomic,retain) LoadObj *objLoader;
@property(nonatomic,retain) CC3GLMatrix *model;
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
- (void)willRender:(CADisplayLink*)displayLink;
- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType;
- (void)compileShaders;
- (void)checkAttribute:(GLuint)attribute name:(const char*)name;
- (GLfloat*)computeNormalsWithElements:(GLushort*)elements noe:(GLushort)noe andVertices:(GLfloat*)vertices nov:(GLushort)nov;
- (void)displayNormals:(GLfloat*)arr noe:(GLushort)numberOfElements;
- (GLfloat*)avarageNormalsWithElements:(GLushort*)arrElements numberOfElements:(GLushort)noe andNormals:(GLfloat*)arrNormals numberOfNormals:(GLushort)non;
@end