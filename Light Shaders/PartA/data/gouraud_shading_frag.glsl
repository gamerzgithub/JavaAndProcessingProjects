//Gouraud Fragment Shader
//Taken from the Subject Guide pg 58 and 59 under Section 4.10
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec4 col;

void main(){
	gl_FragColor = col;
}