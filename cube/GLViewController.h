//
//  GLViewController.h
//  cube
//
//  Created by tzvifi on 7/17/13.
//
//

#import <UIKit/UIKit.h>
@class LoadObj;
@interface GLViewController : UIViewController {
    GLfloat _currentRotationAngle;
}
@property(nonatomic,assign) GLuint positionSlot,
                                    colorSlot,
                                    texture_id,attribute_texcoord;
@property(nonatomic,assign) GLuint modelViewUniform,
                                    projectionUniform,
                                    uniform_mytexture,
                                    lightDirectionUniform;
@property(nonatomic,assign) GLuint vbo_cube_vertices,
                                    vbo_cube_colors,
                                    ibo_cube_elements,
                                    vbo_cube_texcoords;
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
@end