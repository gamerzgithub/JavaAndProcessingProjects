//Part C
//Texture Vertex Shader
//Extended from Part A and B 
/*
REFERENCE:
Overall shader:
https://processing.org/tutorials/pshader/
Image Post-Processing Effects:
Code listing 8.2
https://processing.org/tutorials/pshader/
http://setosa.io/ev/image-kernels/
https://lodev.org/cgtutor/filtering.html
Animation:
http://math.hws.edu/graphicsbook/source/webgl/texture-transform.html
(From the excellent example coursework 2 of 2018-2019)
Brigjaj, J. D.(2019) CO3355 Advanced Graphics coursework 2 Partb, BSc Computing and Information System, University of London, Unpublished.
Displacement code and calculation:
https://github.com/AmnonOwed/P5_CanTut_GeometryTexturesShaders2B8/blob/master/GLSL_SphereDisplacement/data/displaceVert.glsl
Pixel colour calculations:
Wong, D. N. (2019) CO2227 Creative computing II: interactive multimedia coursework1 PartA, BSc Creative Computing, University of London, Unpublished. 
*/
#define PROCESSING_TEXLIGHT_SHADER

uniform mat4 transform;
uniform mat4 texMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D heightMap;
uniform float magnitude;
uniform float animation;

float min;
float max;
float r;
float g;
float b;

void main(){
	
	//Animation of texture
	//Approach: scaling both axis
	float texS = texCoord.s;
	float texT = texCoord.t;
	texS *= animation;
	texT *= animation;
	vec2 animatedVertTexCoord = vec2(texS, texT);
	vertTexCoord = texMatrix * vec4(animatedVertTexCoord, 1.0, 1.0);
	
	//Vertex coordinates and position
	vec4 disVert = texture2D(heightMap, vertTexCoord.st);
	r = disVert.r;
	g = disVert.g;
	b = disVert.b;
	max = max(r, max(g, b));
	min = min(r, min(g, b));
	float saturation = max(0.0, (1 - (min/max))); 
	
	vec4 newVertPos = position + vec4(normal * saturation * magnitude, 0.0);
	
	gl_Position = transform * newVertPos;

	vertColor = color;
	
}