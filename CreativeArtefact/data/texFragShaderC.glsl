//Part C
//Texture Fragment Shader
//Extended from Part A and B
/*REFERENCE:
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
Brigjaj, J. D. (2019) CO3355 Advanced Graphics coursework 2 Partb, BSc Computing and Information System, University of London, Unpublished.
Displacement code and calculation:
https://github.com/AmnonOwed/P5_CanTut_GeometryTexturesShaders2B8/blob/master/GLSL_SphereDisplacement/data/displaceVert.glsl
Pixel colour calculations:
Wong, D. N. (2019) CO2227 Creative computing II: interactive multimedia coursework1 PartA, BSc Creative Computing, University of London, Unpublished. 
*/

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D tex;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform float num1 = 0.0; uniform float num2 = 0.0; uniform float num3 = 0.0;
uniform float num4 = 0.0; uniform float num5 = 1.0; uniform float num6 = 0.0;
uniform float num7 = 0.0; uniform float num8 = 0.0; uniform float num9 = 0.0;

uniform float intensity = 1.0;

void main() {	  
	//Image Post-processing effects (Convolution filters)
	//Getting the texture coordinates and the coordinates of the neighbouring pixels
	vec2 tc1 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
	vec2 tc2 = vertTexCoord.st + vec2(         0.0, -texOffset.t);
	vec2 tc3 = vertTexCoord.st + vec2(+texOffset.s, -texOffset.t);
	vec2 tc4 = vertTexCoord.st + vec2(-texOffset.s,          0.0);
	vec2 tc5 = vertTexCoord.st + vec2(         0.0,          0.0);
	vec2 tc6 = vertTexCoord.st + vec2(+texOffset.s,          0.0);
	vec2 tc7 = vertTexCoord.st + vec2(-texOffset.s, +texOffset.t);
	vec2 tc8 = vertTexCoord.st + vec2(         0.0, +texOffset.t);
	vec2 tc9 = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);

	//Get the colour for each pixel with the given filter
	vec4 col1 = texture2D(tex, tc1);
	vec4 col2 = texture2D(tex, tc2);
	vec4 col3 = texture2D(tex, tc3);
	vec4 col4 = texture2D(tex, tc4);
	vec4 col5 = texture2D(tex, tc5);
	vec4 col6 = texture2D(tex, tc6);
	vec4 col7 = texture2D(tex, tc7);
	vec4 col8 = texture2D(tex, tc8);
	vec4 col9 = texture2D(tex, tc9);

	//Calculate colour
	vec4 sum = 	 col1 * num1 * intensity +
				 col2 * num2 * intensity +
				 col3 * num3 * intensity +
				 col4 * num4 * intensity +
				 col5 * num5 * intensity +
				 col6 * num6 * intensity +
				 col7 * num7 * intensity +
				 col8 * num8 * intensity +
				 col9 * num9 * intensity ;
	
	gl_FragColor = vec4(sum.rgb, 1.0) * vertColor;
}