//Phong Fragment Shader
/*Now that we have done the calculating normal vector and light direction vector for each vertex, we can now calculate the light intensity for each pixel in the Fragment Shader.

CODE TAKEN AND MODIFIED FROM https://processing.org/tutorials/pshader/ UNDER SECTION 'PSHADER CLASS'
*/
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

//The interpolated values from the Vertex Shader
varying vec4 vertCol;
varying vec3 vertNormal;
varying vec3 vertLightDir;

void main(){
	//Calculate colour and light intensity of every pixel
	
	//First normalise light direction vector and normal vector
	vec3 normalisedLightDir = normalize(vertLightDir);
	vec3 normalisedNormal = normalize(vertNormal);
	
	/*Calculate light intensity of each pixel with dot product of normalised light direction vector and normalised normal vector
	*/
	float light = max(0.0, dot(normalisedLightDir,normalisedNormal));
	gl_FragColor = vec4(light, light, light, 1)*vertCol;
}