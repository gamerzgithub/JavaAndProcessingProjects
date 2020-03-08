//Phong Vertex Shader
//Modified from the Phong Vertex Shader in Part A
/*To model spot lighting with phong shader, I choose to use Phong Illumination Model, where ambient reflection, diffused reflection, and specular reflection are involved. 
*With reference to Subject Guide pg66 to pg67,  https://www.cs.uic.edu/~jbell/CourseNotes/ComputerGraphics/LightingAndShading.html 
and https://processing.org/tutorials/pshader/ 
*/
#define PROCESSING_LIGHT_SHADER

uniform mat4 transform;
uniform mat4 modelview;
uniform mat3 normalMatrix;

/*Access all active lights with a uniform vector array. Unlike Gouraud Vertex Shader, 'lightCount' is not needed here as calculations will be done in Fragment Shader for Phong Shading Algorithm.
*/
uniform vec4 lightPosition[8];
uniform vec3 lightNormal[8];
uniform vec2 lightSpot[8];

attribute vec4 vertex;
attribute vec4 color;
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