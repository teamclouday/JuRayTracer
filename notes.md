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
![\nabla f(x,y,z)=\Big(\frac{\partial f}{\partial x},\frac{\partial f}{\partial y},\frac{\partial f}{\partial z}\Big)=\Big(\frac{2x}{a^2},\frac{2y}{b^2},-1\Big)](https://latex.codecogs.com/png.latex?%5Cnabla%20f%28x%2Cy%2Cz%29%3D%5CBig%28%5Cfrac%7B%5Cpartial%20f%7D%7B%5Cpartial%20x%7D%2C%5Cfrac%7B%5Cpartial%20f%7D%7B%5Cpartial%20y%7D%2C%5Cfrac%7B%5Cpartial%20f%7D%7B%5Cpartial%20z%7D%5CBig%29%3D%5CBig%28%5Cfrac%7B2x%7D%7Ba%5E2%7D%2C%5Cfrac%7B2y%7D%7Bb%5E2%7D%2C-1%5CBig%29)  

------

Shadow  

* Point Light Source (Hard Shadow)  
  binary visibility signal, either visible or not (umbra)  
* Area Light Source (Soft Shadow)  
  continous visibility signal (penumbra & umbra)  

Brightness of a point:  
![I\Big(I_\text{light}\frac{\text{\#(visible shadow rays)}}{\text{\#(all shadow rays)}}\Big)](https://latex.codecogs.com/png.latex?I%5CBig%28I_%5Ctext%7Blight%7D%5Cfrac%7B%5Ctext%7B%5C%23%28visible%20shadow%20rays%29%7D%7D%7B%5Ctext%7B%5C%23%28all%20shadow%20rays%29%7D%7D%5CBig%29)  

------

Camera Models  

* Perspective Camera  
  Given ![h,w,f\text{ovx}](https://latex.codecogs.com/png.latex?h%2Cw%2Cf%5Ctext%7Bovx%7D) to compute pixel position (x,y)  
  ![x_p\in(0,w),y_p\in(0,h),f\text{ovx}\in(0,\pi)](https://latex.codecogs.com/png.latex?x_p%5Cin%280%2Cw%29%2Cy_p%5Cin%280%2Ch%29%2Cf%5Ctext%7Bovx%7D%5Cin%280%2C%5Cpi%29)  
  ![f\text{ovy}=\frac{h}{w}\cdot f\text{ovx}](https://latex.codecogs.com/png.latex?f%5Ctext%7Bovy%7D%3D%5Cfrac%7Bh%7D%7Bw%7D%5Ccdot%20f%5Ctext%7Bovx%7D)  
  ![x=\frac{2x_p-w}{w}\tan(f\text{ovx})](https://latex.codecogs.com/png.latex?x%3D%5Cfrac%7B2x_p-w%7D%7Bw%7D%5Ctan%28f%5Ctext%7Bovx%7D%29)  
  ![y=\frac{2y_p-h}{h}\tan(f\text{ovy})](https://latex.codecogs.com/png.latex?y%3D%5Cfrac%7B2y_p-h%7D%7Bh%7D%5Ctan%28f%5Ctext%7Bovy%7D%29)  
  ![z=-1](https://latex.codecogs.com/png.latex?z%3D-1)  
* Orthographic Camera  

------

Recursion  

Illumination Equation:  
![I=k_aI_a+I_i(k_d(\vec{L}\cdot\vec{N})+k_s(\vec{V}\cdot\vec{R})^n)+k_tI_t+k_rI_r](https://latex.codecogs.com/png.latex?I%3Dk_aI_a&plus;I_i%28k_d%28%5Cvec%7BL%7D%5Ccdot%5Cvec%7BN%7D%29&plus;k_s%28%5Cvec%7BV%7D%5Ccdot%5Cvec%7BR%7D%29%5En%29&plus;k_tI_t&plus;k_rI_r)  
* ![k_t](https://latex.codecogs.com/png.latex?k_t) is Fresnel transmission coefficient  
* ![I_t](https://latex.codecogs.com/png.latex?I_t) is intensity from transmission direction  
* ![k_r](https://latex.codecogs.com/png.latex?k_r) is Fresnel reflection coefficient  
* ![I_r](https://latex.codecogs.com/png.latex?I_r) is intensity from reflection direction  

Heckbert's notation:  
* ![L](https://latex.codecogs.com/png.latex?L) is light source  
* ![D](https://latex.codecogs.com/png.latex?D) is diffuse light paths  
* ![S](https://latex.codecogs.com/png.latex?S) is specular light paths  
* ![E](https://latex.codecogs.com/png.latex?E) is eye/camera  
* ![[D]*](https://latex.codecogs.com/png.latex?%5BD%5D*) is any amount of diffuse bounces  
* ![[S|D]](https://latex.codecogs.com/png.latex?%5BS%7CD%5D) is specular or diffuse bounce  

Use the notations  
Ray casting: ![L[D]E](https://latex.codecogs.com/png.latex?L%5BD%5DE)  
Radiosity: ![L[D*]E](https://latex.codecogs.com/png.latex?L%5BD*%5DE)  
Recursive ray tracing: ![L[D]S*E](https://latex.codecogs.com/png.latex?L%5BD%5DS*E)  
Global illumination: ![L[D|S]*E](https://latex.codecogs.com/png.latex?L%5BD%7CS%5D*E)  

------

More BRDF  
* Oren-Nayar BRDF model  
* Phong-Blinn model  
* Cook-Torrance model  
* Ashikhmin-Shirley model  

------

F-Stop Camera (depth of field)  
Send rays through camera focal point and nearby, and average the collected radiance  

------

Recursive Ray Tracing:  
Only approximate local diffuse color, not aware of surrounding  
![I=k_aI_a+I_i(k_d(\vec{L}\cdot\vec{N})+k_s(\vec{V}\cdot\vec{R})^n)+k_tI_t+k_rI_r](https://latex.codecogs.com/png.latex?I%3Dk_aI_a&plus;I_i%28k_d%28%5Cvec%7BL%7D%5Ccdot%5Cvec%7BN%7D%29&plus;k_s%28%5Cvec%7BV%7D%5Ccdot%5Cvec%7BR%7D%29%5En%29&plus;k_tI_t&plus;k_rI_r)  

Global Illumination:  
Take surrounding into consideration when computing diffuse and specular color  
![L_o(x,\vec{w})=L_e(x,\vec{w})+\int_\Omega L_i(x,\vec{w}')f_r(\vec{w},x,\vec{w}')\cos\theta\, \mathrm{d}\vec{w}'](https://latex.codecogs.com/png.latex?L_o%28x%2C%5Cvec%7Bw%7D%29%3DL_e%28x%2C%5Cvec%7Bw%7D%29&plus;%5Cint_%5COmega%20L_i%28x%2C%5Cvec%7Bw%7D%27%29f_r%28%5Cvec%7Bw%7D%2Cx%2C%5Cvec%7Bw%7D%27%29%5Ccos%5Ctheta%5C%2C%20%5Cmathrm%7Bd%7D%5Cvec%7Bw%7D%27)  

Global illumination is much more realistic than recursive ray tracing, but more complicated to compute  

Monte Carlo Integration  
* It's __impossible__ to compute integral of very complex function in closed form, but possible to sample the function  
* Idea is to determine the intergral from the fewest samples  

In order to compute:  
![\int_a^b f(x)\mathrm{d}x](https://latex.codecogs.com/png.latex?%5Cint_a%5Eb%20f%28x%29%5Cmathrm%7Bd%7Dx)  
* Sample either miss or hit  
* Close the function in a box of size A

Then:  
![\int_a^b f(x)\mathrm{d}x/A \approx \frac{\text{hits}}{\text{hits}+\text{miss}}](https://latex.codecogs.com/png.latex?%5Cint_a%5Eb%20f%28x%29%5Cmathrm%7Bd%7Dx/A%20%5Capprox%20%5Cfrac%7B%5Ctext%7Bhits%7D%7D%7B%5Ctext%7Bhits%7D&plus;%5Ctext%7Bmiss%7D%7D)  

------

Space Partitioning

* k-d tree  
  [+] Faster traversal on CPU  
  [-] Larger amount of nodes and duplicate references
* Bounding Volume Hierarchy (BVH)  
  [+] Faster traversal on GPU  
  [+] Easier to update for dynamic scenes  
  [+] Every object only in one tree leaf  
  [-] Spatial overlap of nodes  

------

Bounding Volume Hierarchies

Surface area heuristic (SAH):  
![\text{SAH}=C_\text{inner}\sum_I\frac{A_n}{A_\text{root}}+C_\text{leaf}\sum_LT_n\frac{A_n}{A_\text{root}}](https://latex.codecogs.com/png.latex?%5Ctext%7BSAH%7D%3DC_%5Ctext%7Binner%7D%5Csum_I%5Cfrac%7BA_n%7D%7BA_%5Ctext%7Broot%7D%7D&plus;C_%5Ctext%7Bleaf%7D%5Csum_LT_n%5Cfrac%7BA_n%7D%7BA_%5Ctext%7Broot%7D%7D)  
where:  
* ![I](https://latex.codecogs.com/png.latex?I) are inner nodes  
* ![L](https://latex.codecogs.com/png.latex?L) are leaf nodes  
* ![A_n](https://latex.codecogs.com/png.latex?A_n) is surface area node n  
* ![A_{root}](https://latex.codecogs.com/png.latex?A_{root}) is surface area of its root  

Constructing the tree with minimal SAH cost is expensive, so approximations are often used  

------

Reinhard Tone Mapper  

Global version steps:  
1. Compute log average (luminance space)  
   ![L_{avg}=\exp\Big(\frac{1}{N}\sum_{x,y}\log(L_{input}(x,y))\Big)=\sqrt[N]{\prod_{x,y}L_{input}(x,y)}](https://latex.codecogs.com/png.latex?L_%7Bavg%7D%3D%5Cexp%5CBig%28%5Cfrac%7B1%7D%7BN%7D%5Csum_%7Bx%2Cy%7D%5Clog%28L_%7Binput%7D%28x%2Cy%29%29%5CBig%29%3D%5Csqrt%5BN%5D%7B%5Cprod_%7Bx%2Cy%7DL_%7Binput%7D%28x%2Cy%29%7D)  
2. Map average value to middle-gray given by ![\alpha](https://latex.codecogs.com/png.latex?\alpha)  
   ![L_{scaled}(x,y)=\frac{\alpha}{L_{avg}}L_{input}(x,y)](https://latex.codecogs.com/png.latex?L_%7Bscaled%7D%28x%2Cy%29%3D%5Cfrac%7B%5Calpha%7D%7BL_%7Bavg%7D%7DL_%7Binput%7D%28x%2Cy%29)  
3. Compress high luminances  
   ![L_{output}(x,y)=\frac{L_{scaled}(x,y)}{1+L_{scaled}(x,y)}](https://latex.codecogs.com/png.latex?L_%7Boutput%7D%28x%2Cy%29%3D%5Cfrac%7BL_%7Bscaled%7D%28x%2Cy%29%7D%7B1&plus;L_%7Bscaled%7D%28x%2Cy%29%7D)  

Local version steps:  
1. Compute log average  
2. Map average value to middle-gray given by ![\alpha](https://latex.codecogs.com/png.latex?\alpha)  
3. Compress luminances by spatially varying function  
   ![L_{output}(x,y)=\frac{L_{scaled}(x,y)}{1+V(x,y,s(x,y))}](https://latex.codecogs.com/png.latex?L_%7Boutput%7D%28x%2Cy%29%3D%5Cfrac%7BL_%7Bscaled%7D%28x%2Cy%29%7D%7B1&plus;V%28x%2Cy%2Cs%28x%2Cy%29%29%7D)  

