# Notes

_The following are the important formulas and notations I learned from the "TU Wien Rendering / Ray Tracing Course"_

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

The Fresnel Equation  
![R_s(\theta)=\Bigg|\frac{n_1\cos\theta-n_2\sqrt{1-(\frac{n_1}{n_2}\sin\theta)^2}}{n_1\cos\theta+n_2\sqrt{1-(\frac{n_1}{n_2}\sin\theta)^2}}\Bigg|^2](https://latex.codecogs.com/png.latex?R_s%28%5Ctheta%29%3D%5CBigg%7C%5Cfrac%7Bn_1%5Ccos%5Ctheta-n_2%5Csqrt%7B1-%28%5Cfrac%7Bn_1%7D%7Bn_2%7D%5Csin%5Ctheta%29%5E2%7D%7D%7Bn_1%5Ccos%5Ctheta&plus;n_2%5Csqrt%7B1-%28%5Cfrac%7Bn_1%7D%7Bn_2%7D%5Csin%5Ctheta%29%5E2%7D%7D%5CBigg%7C%5E2)

Approximated by Christophe Schlick  
![R(\theta)=R_0+(1-R_0)(1-\cos\theta)^5](https://latex.codecogs.com/png.latex?R%28%5Ctheta%29%3DR_0&plus;%281-R_0%29%281-%5Ccos%5Ctheta%29%5E5)  
* ![R(\theta)](https://latex.codecogs.com/png.latex?R%28%5Ctheta%29) is probability of reflection  
* ![T(\theta)=1-R(\theta)](https://latex.codecogs.com/png.latex?T%28%5Ctheta%29%3D1-R%28%5Ctheta%29) is probability of refraction  
* ![R_0](https://latex.codecogs.com/png.latex?R_0) is probability of reflection when ![\theta=0](https://latex.codecogs.com/png.latex?%5Ctheta%3D0)  
    ![R_0=\Big(\frac{n_1-n_2}{n_1+n_2}\Big)^2](https://latex.codecogs.com/png.latex?R_0%3D%5CBig%28%5Cfrac%7Bn_1-n_2%7D%7Bn_1&plus;n_2%7D%5CBig%29%5E2)  


![n_\text{medium}=\frac{\text{speed of light in vacuum}}{\text{speed of light in medium}}](https://latex.codecogs.com/png.latex?n_%5Ctext%7Bmedium%7D%3D%5Cfrac%7B%5Ctext%7Bspeed%20of%20light%20in%20vacuum%7D%7D%7B%5Ctext%7Bspeed%20of%20light%20in%20medium%7D%7D)  

Snell's Law  
![\frac{\sin\theta_1}{\sin\theta_2}=\frac{n_2}{n_1}](https://latex.codecogs.com/png.latex?%5Cfrac%7B%5Csin%5Ctheta_1%7D%7B%5Csin%5Ctheta_2%7D%3D%5Cfrac%7Bn_2%7D%7Bn_1%7D)  

------

Ray Representation  
![\vec{r}(t)=\vec{o}+t\vec{d}](https://latex.codecogs.com/png.latex?%5Cvec%7Br%7D%28t%29%3D%5Cvec%7Bo%7D&plus;t%5Cvec%7Bd%7D)  
* ![\vec{o}](https://latex.codecogs.com/png.latex?%5Cvec%7Bo%7D) is origin  
* ![\vec{d}](https://latex.codecogs.com/png.latex?%5Cvec%7Bd%7D) is direction  
* ![t](https://latex.codecogs.com/png.latex?t) is distance  
* ![\|\vec{d}\|=1](https://latex.codecogs.com/png.latex?%5C%7C%5Cvec%7Bd%7D%5C%7C%3D1)  

------

Surface Normal  

For implicit equation ![f(x,y)=0](https://latex.codecogs.com/png.latex?f%28x%2Cy%29%3D0), surface normal is gradient of the function ![\nabla f(x,y)](https://latex.codecogs.com/png.latex?%5Cnabla%20f%28x%2Cy%29)  
Example: Elliptic Paraboloid  
![f(x,y,z)=\frac{x^2}{a^2}+\frac{y^2}{b^2}-z](https://latex.codecogs.com/png.latex?f%28x%2Cy%2Cz%29%3D%5Cfrac%7Bx%5E2%7D%7Ba%5E2%7D&plus;%5Cfrac%7By%5E2%7D%7Bb%5E2%7D-z)  
![\nabla f(x,y,z)=\Big(\frac{\partial f}{\partial x},\frac{\partial f}{\partial y},\frac{\partial f}{\partial z}\Big)](https://latex.codecogs.com/png.latex?%5Cnabla%20f%28x%2Cy%2Cz%29%3D%5CBig%28%5Cfrac%7B%5Cpartial%20f%7D%7B%5Cpartial%20x%7D%2C%5Cfrac%7B%5Cpartial%20f%7D%7B%5Cpartial%20y%7D%2C%5Cfrac%7B%5Cpartial%20f%7D%7B%5Cpartial%20z%7D%5CBig%29)  

------

