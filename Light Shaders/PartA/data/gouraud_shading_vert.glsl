//Gouraud Vertex Shader
#define PROCESSING_LIGHT_SHADER
/*
For R, G, or B value:
C = IaS + Ic(Is+IdS)L
where Ia = ambient reflection
	  Ic = depth cueing
	  Is = specular reflection
	  Id = diffuse reflection
	  S  = surface color
	  L  = Colour of light
In Gouraud Shading, we assume there's no ambient reflection, no attenuation, and no specular reflection. Also we set colour of light to white light, where L = 0. 
Hence the only factor to be taken into consideration is the diffuse reflection 'Id', as well as surface colour 'S'.
Hence, the equation is simplified into: 
C = Id S
Id, diffuse reflection intensity, can be modeled with Lambert's law, and Lambert's law states that
Id is directly proportional to the cosine of the angel between the normal vector of the surface and the direction of the light,
thus 
Id = cos(A) = N.L
where
N = the normal vector of the surface
L = the direction vector of the light
A = the angle between N and L
TAKEN FROM INTERACTIVE COMPUTER GRAPHICS: A TOP-DOWN APPROACH WITH SHADER-BASED OPENGL 6TH EDITION pg 268
*/
/*
*I've explained that in Gouraud shading only Id and S are taken into considerations. 
*In order to implement this in GLSL, the first step: 
*calculate light intensity of the pixel
*I will use a float variable to do this.
*C = IdS = (N.L)S
*In this context,
*N = transformedNormal
*L = lightDir
*Using max(0, a value) to ensure the light intensity value 	will not be negative
*/

//CODE TAKEN FROM SUBJECT GUIDE PG 69
uniform mat4 transform;
uniform mat4 modelview;
uniform mat3 normalMatrix;
uniform vec4 lightPosition;
attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;
varying vec4 col;

void main(){
	gl_Position = transform*vertex;
	vec3 vertexCamera = vec3(modelview*vertex);
	vec3 transformedNormal = normalize(normalMatrix*normal);
	vec3 lightDir = normalize(lightPosition.xyz - vertexCamera);
	

	
	float light = max(0.0, dot(lightDir, transformedNormal));
	col = vec4(light, light, light, 1)*color;
}