//
//  GLView.m
//  cube
//
//  Created by tzviki fisher on 02/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GLView.h"
#import "CC3GLMatrix.h"
#import "CC3Math.h"
#import "CC3Foundation.h"
//#import "fromBlender.h"

typedef struct 
{
    float Position[3];
    float Color[4];
}Vertices;

Vertices cubeVertices[] = {
    //front
    {{-0.5,-0.5,0.5},{1.0,0.0,0.0,1}}, //
    {{0.5,-0.5,0.5},{1.0,0.0,0.0,1}},   ///
    {{-0.5,0.5,0.5},{1.0,.0,0.0,1}},
    {{0.5,0.5,0.5},{1.0,.0,0.0,1}},
    //{{-0.5,-0.5,0.5},{1.0,0.0,0.0,1}}, //
   // {{0.5,-0.5,0.5},{0.0,1.0,0.0,1}},   ///
    //left
    {{-0.5,-0.5,-0.5},{0.0,1.0,0.0,1}},
    {{-0.5,-0.5,0.5},{0.0,1.0,0.0,1}},
    {{-0.5,0.5,0.5},{0.0,1.0,0.0,1}},
   // {{-0.5,0.5,0.5},{1.0,0.0,0.0,1}},
    {{-0.5,0.5,-0.5},{0.0,1.0,0.0,1}},
    //{{-0.5,-0.5,-0.5},{1.0,0.0,0.0,1}},
    //right
    {{0.5,-0.5,-0.5},{0.0,0.0,1.0,1}},
    {{0.5,-0.5,0.5},{0.0,0.0,1.0,1}},
    {{0.5,0.5,0.5},{0.0,0.0,1.0,1}},
    {{0.5,0.5,-0.5},{0.0,0.0,1.0,1}},
    //back
    {{-0.5,-0.5,-0.5},{1.0,1.0,0.0,1}}, //
    {{0.5,-0.5,-0.5},{1.0,1.0,0.0,1}},   ///
    {{-0.5,0.5,-0.5},{1.0,1.0,0.0,1}},
    {{0.5,0.5,-0.5},{1.0,1.0,0.0,1}},
    //top
    {{0.5,0.5,0.5},{0.0,1.0,1.0,1}},
    {{0.5,0.5,-0.5},{0.0,1.0,1.0,1}},
    {{-0.5,0.5,-0.5},{0.0,1.0,1.0,1}},
    {{-0.5,0.5,0.5},{0.0,1.0,1.0,1}},
    //bottom
    {{0.5,-0.5,0.5},{1.0,0.0,1.0,1}},
    {{0.5,-0.5,-0.5},{1.0,0.0,1.0,1}},
    {{-0.5,-0.5,-0.5},{1.0,0.0,1.0,1}},
    {{-0.5,-0.5,0.5},{1.0,0.0,1.0,1}}
};
GLubyte CubeIndices[] = {0,1,2,1,2,3,4,5,6,4,6,7,8,9,10,8,10,11,12,13,14,15,13,14,16,17,18,16,18,19,20,21,22,20,22,23};

Vertices triangleVertices[] = {
    {{0.0,0.8,0},{1.0,0.0,0.0}},
    {{-0.8,-0.8,0},{0.0,1.0,0.0}},
    {{0.8,-0.8,0},{0.0,0.0,1.0}}
    };
@implementation GLView

+ (Class)layerClass { // set up openGL view
    return [CAEAGLLayer class];
}

- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    _timeSinceLastUpdate = 0;
    _timeRotation = 0;
}


// Replace initWithFrame with this
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        [self setupLayer];        
        [self setupContext];     
        [self setupDepthBuffer];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self compileShaders];
        [self setupVBOs];
        [self setupDisplayLink];
        [self createGestureRecognizers];
        
        m_factor = 1.0;
       
    }
    return self;
}

- (void)setupLayer { // set leyer to opaque
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES; // by default is opaque set to NO, so we change because of better
    // preformance reasons to YES.
}

// 5) Create OpenGL context

- (void)setupContext {
    
    /*To do anything with OpenGL, you need to create an EAGLContext, and set the current context to the newly created context.
     An EAGLContext manages all of the information iOS needs to draw with OpenGL. It’s similar to how you need a Core Graphics context to do anything with Core Graphics.
     When you create a context, you specify what version of the API you want to use. Here, you specify that you want to use OpenGL ES 2.0. If it is not available (such as if the program was run on an iPhone 3G), the app would terminate.*/
    
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}



// 6) Create a render buffer

- (void)setupRenderBuffer {
    
    /*The next step to use OpenGL is to create a render buffer, which is an OpenGL object that stores the rendered image to present to the screen.
     Sometimes you’ll see a render buffer also referred to as a color buffer, because in essence it’s storing colors to display!
     There are three steps to create a render buffer:
     Call glGenRenderbuffers to create a new render buffer object. This returns a unique integer for the the render buffer (we store it here in _colorRenderBuffer). Sometimes you’ll see this unique integer referred to as an “OpenGL name.”
     Call glBindRenderbuffer to tell OpenGL “whenever I refer to GL_RENDERBUFFER, I really mean _colorRenderBuffer.”
     Finally, allocate some storage for the render buffer. The EAGLContext you created earlier has a method you can use for this called renderbufferStorage.*/
    
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);        
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);    
}

// 7) Create a frame buffer

- (void)setupFrameBuffer {
    
    /*A frame buffer is an OpenGL object that contains a render buffer, and some other buffers you’ll learn about later such as a depth buffer, stencil buffer, and accumulation buffer.
     The first two steps for creating a frame buffer is very similar to creating a render buffer – it uses the glGen and glBind like you’ve seen before, just ending with “Framebuffer/s” instead of “Renderbuffer/s”.
     The last function call (glFramebufferRenderbuffer) is new however. It lets you attach the render buffer you created earlier to the frame buffer’s GL_COLOR_ATTACHMENT0 slot.*/
    
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, 
                              GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);    
}
- (void)compileShaders {
    
    /*
     1. Uses the method you just wrote to compile the vertex and fragment shaders.
     2. Calls glCreateProgram, glAttachShader, and glLinkProgram to link the vertex and fragment shaders into a complete program.
     3. Calls glGetProgramiv and glGetProgramInfoLog to check and see if there were any link errors, and display the output and quit if so.
     4. Calls glUseProgram to tell OpenGL to actually use this program when given vertex info.
     5. Finally, calls glGetAttribLocation to get a pointer to the input values for the vertex shader, so we can set them in code. Also calls glEnableVertexAttribArray to enable use of these arrays (they are disabled by default).
     */
    
    // 1
    GLuint vertexShader = [self compileShader:@"SimpleVertex" 
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment" 
                                       withType:GL_FRAGMENT_SHADER];
    
    // 2
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4
    glUseProgram(programHandle);
    
    // 5
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    const char* uniform_name;
    uniform_name = "fade";
    
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    glEnableVertexAttribArray(_uniform_fade);
    
    
    _projectionUniform = glGetUniformLocation(programHandle, "Projection");
    _modelViewUniform = glGetUniformLocation(programHandle, "Modelview");
    _uniform_fade = glGetUniformLocation(programHandle, uniform_name);
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    /*
     1. Gets an NSString with the contents of the file. This is regular old UIKit programming, many of you should be used to this kind of stuff already.
     2. Calls glCreateShader to create a OpenGL object to represent the shader. When you call this function you need to pass in a shaderType to indicate whether it’s a fragment or vertex shader. We take ethis as a parameter to this method.
     3. Calls glShaderSource to give OpenGL the source code for this shader. We do some conversion here to convert the source code from an NSString to a C-string.
     4. Finally, calls glCompileShader to compile the shader at runtime!
     5. This can fail – and it will in practice if your GLSL code has errors in it. When it does fail, it’s useful to get some output messages in terms of what went wrong. This code uses glGetShaderiv and glGetShaderInfoLog to output any error messages to the screen (and quit so you can fix the bug!)
     */
    
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName 
                                                           ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath 
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2
    GLuint shaderHandle = glCreateShader(shaderType);    
    
    // 3
    const char * shaderStringUTF8 = [shaderString UTF8String];    
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}
- (void)createGestureRecognizers {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handlePinchGesture:)];
    [self addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    
    UITapGestureRecognizer *oneTapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleOneTapGesture:)];
    oneTapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:oneTapGesture];
    [oneTapGesture release];
    
    UITapGestureRecognizer *twoTapGesture = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleTwoTapGesture:)];
    twoTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:twoTapGesture];
    [twoTapGesture release];
}
- (void)handleOneTapGesture:(UITapGestureRecognizer *)sender {
    m_factor *= 2;
}
- (void)handleTwoTapGesture:(UITapGestureRecognizer *)sender {
    m_factor /= 2;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    m_factor = [(UIPinchGestureRecognizer *)sender scale];
}

- (void)setupVBOs {
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(triangleVertices), triangleVertices, GL_STATIC_DRAW);
    
//    glGenBuffers(1, &_indexBuffer);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
//    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(CubeIndices), CubeIndices, GL_STATIC_DRAW);
    
//    glGenBuffers(1, &_vertexBuffer2);
//    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices2), Vertices2, GL_STATIC_DRAW);
//    
//    glGenBuffers(1, &_indexBuffer2);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
//    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices2), Indices2, GL_STATIC_DRAW);
    _currentRotataion = 0;
}

// 8) Clear the screens

- (void)render:(CADisplayLink*)displayLink {
    [self update:displayLink];
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //glEnable(GL_CULL_FACE);
    //glEnable(GL_DEPTH_TEST);
    //glCullFace(GL_BACK);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    //CC3GLMatrix *projection = [CC3GLMatrix identity];
    
    float h = 4.0f * self.frame.size.height / self.frame.size.width;
    [projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:0.1 andFar:10];
    projection = [CC3GLMatrix identity];
    glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
    
    CC3GLMatrix *modelView = [CC3GLMatrix identity];
    CC3Vector translateVector;
    translateVector.x = 0;
    translateVector.y = -0;
    translateVector.z = -1;

    CC3Vector scale = kCC3VectorUnitCube;
    //float factor = m_factor;
    //scale.x = factor;scale.y=factor;scale.z=factor;
    //scale = CC3VectorScaleUniform(scale, 10);
    //scale = CC3VectorScale(scale, scale);
    //[modelView populateFromScale:scale];
    //[modelView scaleBy:scale];
    CC3GLMatrix *translate = [CC3GLMatrix matrix];
    [translate populateFromTranslation:translateVector];
    //[modelView multiplyByMatrix:translate];
    _timeRotation += displayLink.duration;
    if (_timeRotation > 1) {
        _currentRotataion += 45;
        _timeRotation = 0;
    }
    
//    if (_currentRotataion > 360) {
//        _currentRotataion = 0;
//    }
    CC3Vector rotate;
    rotate.x = 0;rotate.y=0;
    ;rotate.z=_currentRotataion;
    [modelView rotateBy:rotate];
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);   
    //glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    //glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertices),(GLvoid*)0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertices), (GLvoid*)(sizeof(GLfloat)*3));
    GLfloat fade = sinf(_timeSinceLastUpdate / 2 *(2*M_PI)) / 2  + 0.5;
    //NSLog([NSString stringWithFormat:@"time since last update:%f",fade]);
    glUniform1f(_uniform_fade, fade);
    glDrawArrays(GL_TRIANGLES,0,sizeof(triangleVertices)/sizeof(triangleVertices[0]));
    //glDrawElements(GL_TRIANGLES, sizeof(CubeIndices)/sizeof(CubeIndices[0]), GL_UNSIGNED_BYTE, 0);
     
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}
- (void)update:(CADisplayLink*)displayLink {
    _timeSinceLastUpdate += displayLink.duration;
    if (_timeSinceLastUpdate > MAXFLOAT - 1) {
        _timeSinceLastUpdate = 0;
    }
    //NSLog([NSString stringWithFormat:@"time since last update:%f",_timeSinceLastUpdate]);
    
}
@end
