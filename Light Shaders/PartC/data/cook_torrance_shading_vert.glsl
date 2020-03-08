//Cook-Torrance Vertex Shader
//Modified from the Phong Vertex Shader in Part B
/*REFERENCES
[1] 	A. Colubri, "Shaders," 2020. [Online]. Available: https://processing.org/tutorials/pshader/. [Accessed 14 January 2020].
*/
#define PROCESSING_LIGHT_SHADER

uniform mat4 transform;
uniform mat4 modelview;
uniform mat3 normalMatrix;

uniform vec4 lightPosition[8];
uniform vec3 lightNormal[8];

attribute vec4 vertex;
attribute vec3 normal;

varying vec3 vertNorm;
varying vec3 vertPos;


void main(){
	gl_Position = transform*vertex;
	
	//note for this shader all calculations including normalisations will be done in fragment shader	
	//Calculate Vertex Position by transforming by modelview matrix
	vec4 vertCam = modelview*vec4(vertex.xyz, 1.0);
	vertPos= vec3(vertCam)/vertCam.w;
	
	//Transform normal
	vertNorm = vec3(normalMatrix*normal);
	
}