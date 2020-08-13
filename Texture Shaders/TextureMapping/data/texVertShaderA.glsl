//Part A
//Texture Vertex Shader
/*REFERENCE:
Overall texture shader:
https://processing.org/tutorials/pshader/
Image Post-Processing Effects:
Code listing 8.2
https://processing.org/tutorials/pshader/
http://setosa.io/ev/image-kernels/
https://lodev.org/cgtutor/filtering.html
Animation:
http://math.hws.edu/graphicsbook/source/webgl/texture-transform.html
(From the excellent example coursework 2 of 2018-2019)
Brigjaj, J. D. (2019) CO3355 Advanced Graphics and Animation coursework 2 Partb, BSc Computing and Information System, University of London, Unpublished.
*/
#define PROCESSING_TEXLIGHT_SHADER
uniform mat4 transform;
uniform mat4 texMatrix;
uniform float animation;

attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(){
	gl_Position = transform*position;
	
	//Animation of texture
	//Approach: scaling both axis
	float texS = texCoord.s;
	float texT = texCoord.t;
	texS *= animation;
	texT *= animation;
	vec2 animatedVertTexCoord = vec2(texS, texT);
	
	vertColor = color; 

	vertTexCoord = texMatrix * vec4(animatedVertTexCoord, 1.0, 1.0);
}