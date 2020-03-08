//Gouraud Fragment Shader
//Gouraud Fragment Shader from Part A
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec4 col;

void main(){
	gl_FragColor = col;
}