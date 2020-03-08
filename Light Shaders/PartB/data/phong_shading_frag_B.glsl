//Phong Fragment Shader
//Modified from the Phong Fragment Shader in Part A
//REFERENCE
/*
INTERACTIVE COMPUTER GRAPHICS: A TOP-DOWN APPROACH WITH SHADER-BASED OPENGL 6TH EDITION, CHAPTER 5
https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/reflect.xhtml
https://processing.org/tutorials/pshader/
https://processing.org/tutorials/p3d/ 
*/

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec3 vertNorm;
varying vec3 vertPos;

//Access multiple lights
uniform int lightCount;
uniform vec4 lightPosition[8];
uniform vec3 lightNormal[8];
uniform vec2 lightSpot[8];

//Apply Phong Illumination Model
//Ambient Reflection
const vec3 ambReflect = vec3(0.1,0.1,0.1);

//Diffuse Reflection
vec3 diffReflect;

//Specular Reflection
vec3 specReflect;

//Shininess
float sh;

void main(){
	
	float rLight = 0.0;
	float gLight = 0.0;
	float bLight = 0.0;
	
	//Loop with lightCount to access all active lights and perform calculations
	for (int i = 0; i < lightCount; i++){
		//Nomalisation 
		vec3 normal = normalize(vertNorm);
		vec3 lightDir = normalize(lightNormal[i]*-1.0);
		
		/*Map diffuse and specular component, and shininess to the angle and concentration of spotlight respectively, so that the alteration effect of angle and concentration of the spotlight will be reflected on the object.*/
		diffReflect = vec3(lightSpot[i].x, lightSpot[i].x, lightSpot[i].x);
		
		specReflect = vec3(lightSpot[i].x, lightSpot[i].x, lightSpot[i].x);
		sh = lightSpot[i].y;
		
		//Ambient = kaLa, so no calculations required, just use the vector 'ambReflect' directly.
		
		//Calculate Diffuse
		float diff = max(dot(lightDir, normal), 0.0);
		
		//Calculate Specular
		float spec = 0.0;
		if (diff > 0.0) {
			vec3 viewerDir = normalize(-vertPos);
			vec3 reflectDir = reflect(-lightDir, normal);
			spec = pow(max(dot(viewerDir, reflectDir), 0.0), sh);		
		}
		
		//Combine all components
		vec3 color = ambReflect + 
					 diff * diffReflect +
					 spec * specReflect;
					 
		//Now apply to all Red, Green, and Blue lights	
		rLight += color.x;
		gLight += color.y;
		bLight += color.z;
	}
	
	//Lastly, apply the light colors to gl_FragColor.
	gl_FragColor = vec4(rLight, gLight, bLight, 1.0);
}
		
