//Phong Vertex Shader
#define PROCESSING_LIGHT_SHADER
/*
Procedure of Phong Shader
1. For each vertex, calculate the normal vector and light direction vector in Vertex Shader
2. Linearly interpolates the normal vector and light direction vector across the surface of the polygon. (Automatically done by Processing when passing from Vertex Shader to Fragment Shader.)
3. Caculate C value using the interpolated normal vector and light direction vector on each pixel in the Fragment Shader.
TAKEN FROM THE SUBJECT GUIDE pg 68 to 70

For Phong Shader, instead of caculating light for each vertex and pass to fragment as a varying variable, we need to calculate the world space vertex position and normals, and pass them to the Fragment Shader. The light calculations will be done in Fragment Shader. 
TAKEN FROM SUBJECT GUIDE PG 70

That means, light calculations have to be done for every pixel. 
*/

/*CODE TAKEN FROM SUBJECT GUIDE PG 69 WITH MODIFICATIONS DONE ACCORDING TO THE INSTRUCTIONS FROM SUBJECT GUIDE PG 70 'LEARNING ACTIVITY' AND https://processing.org/tutorials/pshader/ SECTION 'PSHADER CLASS'
*/
uniform mat4 transform;
uniform mat4 modelview;
uniform mat3 normalMatrix;
uniform vec4 lightPosition;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

//The VARYING variables to be passed to Fragment Shader
varying vec4 vertCol;
varying vec3 vertNormal;
varying vec3 vertLightDir;

void main(){
	gl_Position = transform*vertex;
	vec3 vertexCamera = vec3(modelview*vertex);
	
	vertNormal = normalize(normalMatrix*normal);
	vertLightDir = normalize(lightPosition.xyz - vertexCamera);
	vertCol = color;
}