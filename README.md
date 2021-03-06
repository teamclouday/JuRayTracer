# JuRayTracer

A simple ray tracer implemented in pure Julia  
Just for fun  

------

I learned the basics of ray tracing from [TU Wien Rendering / Ray Tracing Course](https://www.youtube.com/playlist?list=PLujxSBD-JXgnGmsn7gEyN28P1DnRZG7qi)  
It's a great series of introductory courses  

-----

See `notes.md` for the necessary formulas and notations for this topic  

-----

Cube and Plane (single light source)  
![cube1](gallary/cube1.png)  
![cube2](gallary/cube2.png)  

Cube and Plane (double light sources)  
![cube3](gallary/cube3.png)  
![cube4](gallary/cube4.png)  

Cube and Plane (multiple light sources)  
![cube5](gallary/cube5.png)  

Cube and 2 Planes (single light source)  
![cube6](gallary/cube6.png)  


-----

### Tone Mapping Operators (off topic)  

Original Image:  
<img src="gallary/memorial.jpg" width="200" alt="original">

__Reinhard__ (global version), alpha = 3.0:  
<img src="gallary/mapped1_1.png" width="200" alt="mapped1_1">

__Reinhard__ (global version), alpha = 1/3.0:  
<img src="gallary/mapped1_2.png" width="200" alt="mapped1_2">


