//Cook-Torrance Fragment Shader
//Modified from the Phong Fragment Shader in Part B
/*REFERENCES
[1] J. d. Vries, "PBR - Theory," 2017. [Online]. Available: https://learnopengl.com/PBR/Theory.
[2] K. Kolaczynski, "synthclipse-demos/src/jsx-demos/lighting-models/shaders/model/cook-torrance.glsl," 15 August 2014. [Online]. Available: https://github.com/kamil-kolaczynski/synthclipse-demos/blob/master/src/jsx-demos/lighting-models/shaders/model/cook-torrance.glsl. [Accessed 14 January 2020].
[3] R. L. Cook and K. E. Torrance, "A Reflectance Model for Computer Graphics," ACM Transactions on Graphics, Vol 1, No. 1, pp. 7-24, 1982. 
[4] J. D. Vries, "PBR - Lighting," 2017. [Online]. Available: https://learnopengl.com/PBR/Lighting. [Accessed 13 January 2020].
[5] I. Dunn, "Chapter 33: Fresnel an Beer's Law," 2020. [Online]. Available: https://graphicscompendium.com/raytracing/11-fresnel-beer. [Accessed 15 January 2020].
[6] 	A. Colubri, "Shaders," 2020. [Online]. Available: https://processing.org/tutorials/pshader/. [Accessed 14 January 2020].
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

//Default modelling material 
//Ambient Reflection
uniform vec3 ambReflect = vec3(0.19125, 0.0735, 0.0225);

//Diffuse Reflection
uniform vec3 diffReflect = vec3(0.7038, 0.27048, 0.0828);

//Specular Reflection
uniform vec3 specReflect = vec3(0.256777, 0.137622, 0.086014);
float D;
float G;
float F;

//Shininess
uniform float sh = 12.8;
uniform float metalness = 0.7;
float F0 = sh;

//Roughness
uniform float m = 1.5; // root mean square slope
const float rMode = 0;

#define ROUGHNESS_GAUSSIAN 1
#define ROUGHNESS_BECKMANN 0

//Other parameters and aliases
vec3 normal;
vec3 lightDir;
vec3 viewerDir;
vec3 reflectDir;
vec3 halfVect;

//Dot product
float NdotL;
float NdotH;
float NdotV;
float VdotH;
float m_sq;
float alpha;


void main(){
	//Map diffuse component and shininess to the angle and concentration of spotlight respectively
	
	float rLight = 0.0;
	float gLight = 0.0;
	float bLight = 0.0;
	
	//Loop with lightCount to access all active lights and perform calculations
	for (int i = 0; i < lightCount; i++){
		//Nomalisation and instantiation of parameters
		//N
		normal = normalize(vertNorm);
		//L
		lightDir = normalize(lightNormal[i]*-1.0);
		//V 
		viewerDir = normalize(-vertPos);
		//H 
		halfVect = normalize(lightDir + viewerDir);
		
		//With reference to [2]
		NdotL = max(dot(normal, lightDir),0.0);
		NdotH = max(dot(normal, halfVect), 0.0);
		NdotV = max(dot(normal, viewerDir), 0.0);
		VdotH = max(dot(viewerDir, halfVect), 0.0);
		m_sq = m*m;
		alpha = acos(NdotH);
		
		//Ambient = Ambient Light intensity, no calculation required, directly take from 'ambReflect'.
		
		//Calculate Diffuse
		float diff = NdotL;
		
		//Calculate Specular
		//Facet Slope Distribution
		//GAUSSIAN MODEL with reference to [2] and [3] 
		if (ROUGHNESS_GAUSSIAN == rMode){
			float c = 1.0;
			D = c*exp(-(alpha/m_sq));
		}
		//BECKMAN MODEL with reference to [2] and [3]
		if (ROUGHNESS_BECKMANN == rMode){
			float d1 = 1.0 / (m_sq*pow(cos(alpha),4));
			float d2 = -pow(tan(alpha), 2);
			float d3 = (1.0 / m_sq);
			D = d1 * exp(d2/d3);
		}
		
		//Geometrical Attenuation
		//With reference to [2] and [3]
		float gn = 2.0*NdotH;
		float gd = VdotH;
		float ggxLight = (gn*NdotL)/gd;
		float ggxViewer = (gn*NdotV)/gd;
		G = min(1.0, min(ggxLight, ggxViewer));
		
		//Fresnel Equation (Approximation)
		//With reference to [1], [2], and [5]
		F0 = mix(float(ambReflect), F0, metalness); 
		F = F0 + (1.0 - F0)*pow((1.0 - (VdotH)), 5);
		
		//Combine into Specular
		//With reference to [3]
		float spec = 0.0;
		float sn = float(F*D*G);
		float sd = 3.142*NdotV*NdotL;
		if (diff > 0.0) {
			spec = (sn/sd);
		}
		
		vec3 color = ambReflect+ 
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



//Code for the Cook-Torrance shading model done with references listed at the top of the code

/*From [3], Facet Slope Distribution Function D, referred as Roughness term in [2], is given by two types of formulation:
GAUSSIAN MODEL
D = ce^-(α/m)^2
BECKMAN MODEL
		  1				tan(α)
D = -------------(e^{-[--------]^2})	
	m^2(cos^4(α))		  m

c - arbitraty constant
e - exponent
α - alpha, angle between N and H
m - root mean square slope of facets (in [2] this is represented as the roughnessValue)
*/
/*From [3], Geometrical attentuation factor G is given by:
			2(N.H)(N.V)	  2(N.H)(N.L)
G = min{ 1, ----------- , -----------}
				(V.H)		(V.H)
N - normal vector
L - light vector
V - vector in viewer's direction
*/
/*From [3], Fresnel equation for unpolarized incident light and k = 0 is given by:
	1 (g - c)^2	     [c(g + c) - 1]^2
F = - --------- {1 + -----------------} 
	2 (g + c)^2      [c(g - c) + 1]^2
theta - angle of illumination
c 	  = cos(theta)
g^2   = c^2 + n^2 - 1
n 	  - index of refraction

At normal incidence, where theta = 0, c = 1, g = n, F is given by:
	  n - 1	
F0 = {-----}^2
	  n + 1
However calculating color shift from the Fresnel equation is computationally expensive[3]. Thus it can be simplified by using Fresnel-Sclick approximation [1], and this approximation is further supported by [5]:
Fs = F0 + (1 - F0)(1 - (v.h))^5
*/
