include("./renderbase.jl")
include("./raytracer.jl")

import .JuRenderBase
import .JuRayTracer

function renderCube()
    camera = JuRenderBase.Camera([10.0, 10.0, 10.0], [9.0, 9.0, 9.0], [0.0, 1.0, 0.0], 400, 400, deg2rad(60))
    println("Camera settled")
    objs = JuRenderBase.loadObjs("cube.obj")
    cube = objs[1]
    plane = objs[2]
    mat = JuRenderBase.mat_translate([0.0, 0.0, 0.0]) * JuRenderBase.mat_scale(1.0)
    light1 = JuRenderBase.Light([5.0, 5.0, 0.0], [0.8, 0.8, 0.8])
    light2 = JuRenderBase.Light([0.0, 5.0, 5.0], [0.6, 0.6, 0.6])
    world = JuRenderBase.World([(cube,mat),(plane,mat)], [light1,light2], [0.0, 0.0, 0.0])
    println("World prepared")

    println("Ray tracing start")
    pixels::Array{Float64} = JuRayTracer.render(world, camera, max_depth=20)
    println("Ray tracing finished")

    JuRenderBase.saveImage("cube.png", pixels, camera.w, camera.h)
end

renderCube()