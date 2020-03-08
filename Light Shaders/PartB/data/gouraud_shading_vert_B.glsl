//Gouraud Vertex Shader
//Modifying from the Gouraud Vertex Shader in Part A
#define PROCESSING_LIGHT_SHADER

uniform mat4 transform;
uniform mat4 modelview;
uniform mat3 normalMatrix;

/*With reference from Subject Guide page 70, 
use multiple lights to model spotlight
*/
uniform int lightCount;
uniform vec4 lightPosition[8];
uniform vec3 lightNormal[8];
uniform vec2 lightSpot[8];

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

varying vec4 col;

void main(){

	gl_Position = transform*vertex;
	vec3 vertexCamera = vec3(modelview*vertex);
	vec3 transformedNormal = normalize(normalMatrix*normal);
	
	
	float light = 0.0;
	/*Access active lights by looping with LightCount to do lighting calculations on every active light.
	*/
	for (int i = 0; i < lightCount; i++){
		vec3 lightDir = normalize(lightNormal[i]*-1.0);
		//Here when adding the dot product of normal and light direction vector, multiply the angle and concentration of spotlight such that the light will be affected when angle and concentration are changed.
		light += max(dot(lightDir, transformedNormal), 0.1)*lightSpot[i].x*1/lightSpot[i].y*20;
	}
	
	col = vec4(light, light, light, 1);
}