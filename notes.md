# Notes

_The following are the important formulas and notations I learned from the Ray Tracing Course_

------

Scalar Product:  
![\vec{a}\cdot\vec{b}=\|\hat{a}\|\cdot\|\hat{b}\|\cos\theta](https://latex.codecogs.com/png.latex?%5Cvec%7Ba%7D%5Ccdot%5Cvec%7Bb%7D%3D%5C%7C%5Chat%7Ba%7D%5C%7C%5Ccdot%5C%7C%5Chat%7Bb%7D%5C%7C%5Ccos%5Ctheta)  
With unit length vector:  
![\vec{a}\cdot\vec{b}=\cos\theta](https://latex.codecogs.com/png.latex?%5Cvec%7Ba%7D%5Ccdot%5Cvec%7Bb%7D%3D%5Ccos%5Ctheta)  

------

Terminology:  
* ![\vec{V}](https://latex.codecogs.com/png.latex?%5Cvec%7BV%7D): pointing to viewer (eye, camera)  
* ![\vec{N}](https://latex.codecogs.com/png.latex?%5Cvec%7BN%7D): surface normal  
* ![\vec{L}](https://latex.codecogs.com/png.latex?%5Cvec%7BL%7D): pointing to light source  
* ![\vec{R}](https://latex.codecogs.com/png.latex?%5Cvec%7BR%7D): reflected ray  
* ![\theta_i](https://latex.codecogs.com/png.latex?%5Ctheta_i): incident angle  
* ![\theta_r](https://latex.codecogs.com/png.latex?%5Ctheta_r): reflected angle  

------

BRDF (Bidirectional Reflectance Distribution Function)  
BTDF (Bidirectional Transmittance Distribution Function)  
generalized to  
BSDF (Bidirectional Scattering Distribution Function), or BxDF  

BRDF:  
![f_r(\vec{w},x,\vec{w}')](https://latex.codecogs.com/png.latex?f_r%28%5Cvec%7Bw%7D%2Cx%2C%5Cvec%7Bw%7D%27%29)  
(incoming direction, point on surface, outgoing direction)  

Rendering: Light exiting surface = Light emitted + Light reflected  
![L_o(x,\vec{w})=L_e(x,\vec{w})+\int_\Omega L_i(x,\vec{w}')f_r(\vec{w},x,\vec{w}')\cos\theta\, \mathrm{d}\vec{w}'](https://latex.codecogs.com/png.latex?L_o%28x%2C%5Cvec%7Bw%7D%29%3DL_e%28x%2C%5Cvec%7Bw%7D%29&plus;%5Cint_%5COmega%20L_i%28x%2C%5Cvec%7Bw%7D%27%29f_r%28%5Cvec%7Bw%7D%2Cx%2C%5Cvec%7Bw%7D%27%29%5Ccos%5Ctheta%5C%2C%20%5Cmathrm%7Bd%7D%5Cvec%7Bw%7D%27)  

Simplify (Phong Reflection Model):  
* Ambient BRDF: ![I=k_aI_a](https://latex.codecogs.com/png.latex?I%3Dk_aI_a)  
  where ![k_a](https://latex.codecogs.com/png.latex?k_a) is ambient coefficient of object, ![I_a](https://latex.codecogs.com/png.latex?I_a) is ambient intensity of scene/light source  
* Diffuse BRDF: ![I=k_d(\vec{L}\cdot\vec{N})](https://latex.codecogs.com/png.latex?I%3Dk_d%28%5Cvec%7BL%7D%5Ccdot%5Cvec%7BN%7D%29)  
  where ![k_d](https://latex.codecogs.com/png.latex?k_d) is diffuse coefficient of object  
* Specular BRDF: ![I=k_s(\vec{V}\cdot\vec{R})^n](https://latex.codecogs.com/png.latex?I%3Dk_s%28%5Cvec%7BV%7D%5Ccdot%5Cvec%7BR%7D%29%5En)  
  where ![k_s](https://latex.codecogs.com/png.latex?k_s) is specular coefficient of object, ![(\cdot)^n](https://latex.codecogs.com/png.latex?%28%5Ccdot%29%5En) is shininess factor  

Simplified Rendering Equation:  
![I=k_aI_a+I_i(k_d(\vec{L}\cdot\vec{N})+k_s(\vec{V}\cdot\vec{R})^n)](https://latex.codecogs.com/png.latex?I%3Dk_aI_a&plus;I_i%28k_d%28%5Cvec%7BL%7D%5Ccdot%5Cvec%7BN%7D%29&plus;k_s%28%5Cvec%7BV%7D%5Ccdot%5Cvec%7BR%7D%29%5En%29)  

------

