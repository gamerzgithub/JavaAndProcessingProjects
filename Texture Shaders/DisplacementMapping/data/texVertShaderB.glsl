//Part B
//Texture Vertex Shader
//Extended from Part A
/*REFERENCES:
Overall texture shader:
https://processing.org/tutorials/pshader/
Image Post-Processing Effects:
Code listing 8.2
https://processing.org/tutorials/pshader/
http://setosa.io/ev/image-kernels/
https://lodev.org/cgtutor/filtering.html
Displacement calculations:
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

float min;
float max;
float r;
float g;
float b;
float PI = 3.142;


//NOT USED BUT PRESENTED IN REPORT
float hueCalc() {
  if (max == min) {
    return 0;
  } else if (max == r) {
    return float((PI/3.0) * mod(((g-b)/(max-min)), (2*PI)));
  } else if (max == g) {
    return PI*2.0/3.0 + PI/3.0 * (b-r)/(max-min);
  } else {
    return PI*4.0/3.0 + PI/3.0 * (r-g)/(max-min);
  }
}


void main(){
	vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
	vec4 disVert = texture2D(heightMap, vertTexCoord.st);
	
	r = disVert.r;
	g = disVert.g;
	b = disVert.b;
	max = max(r, max(g, b));
	min = min(r, min(g, b));
	//float hue = mod(hueCalc()*2,100.0)/100.0;
	//float brightness = max;
	float saturation = max(0.0, (1 - (min/max))); 
	//float average = (r+g+b)/3.0;
	
	vec4 newVertPos = position + vec4(normal * saturation * magnitude, 0.0);
	
	gl_Position = transform*newVertPos;
	
	vertColor = color;
	
}