include("./renderbase.jl")
include("./raytracer.jl")

import .JuRenderBase
import .JuRayTracer

function renderCube()
    objs = JuRenderBase.loadObjs("cube.obj")
    cube = objs[1]
    plane = objs[2]
    mat = JuRenderBase.mat_translate([0.0, 0.0, -2.0]) * JuRenderBase.mat_rotate([0.0, 0.0, 1.0], deg2rad(45)) * JuRenderBase.mat_scale(0.5)
    light = JuRenderBase.Light([1.0, 1.0, 1.0], [1.0, 1.0, 1.0])
    world = JuRenderBase.World([(cube,mat),(plane,mat)], [light], [0.0, 0.0, 0.0])
    println("World prepared")
    camera = JuRenderBase.Camera([0.0, 0.0, 1.0], [0.0, 0.0, -1.0], 600, 400, deg2rad(60))
    println("Camera settled")

    println("Ray tracing start")
    pixels::Array{Float64} = JuRayTracer.render(world, camera, max_depth=5)
    println("Ray tracing finished")

    JuRenderBase.saveImage("cube.png", pixels, camera.w, camera.h)
end

renderCube()