include("./renderbase.jl")
include("./raytracer.jl")

import .JuRenderBase
import .JuRayTracer

function renderCube()
    camera = JuRenderBase.Camera([10.0, 10.0, 10.0], [0.0, 0.0, 0.0], [0.0, 1.0, 0.0], 400, 400, deg2rad(60), 0.1, 1000.0)
    println("Camera settled")
    objs = JuRenderBase.loadObjs("cube.obj")
    cube = objs[1]
    plane = objs[2]
    mat = JuRenderBase.mat_perspective(camera) * JuRenderBase.mat_view(camera) * JuRenderBase.mat_translate([0.0, 0.0, -5.0]) * JuRenderBase.mat_scale(0.5)
    light = JuRenderBase.Light([30.0, 30.0, 30.0], [1.0, 1.0, 1.0])
    world = JuRenderBase.World([(plane,mat)], [light], [1.0, 1.0, 1.0])
    println("World prepared")

    println("Ray tracing start")
    pixels::Array{Float64} = JuRayTracer.render(world, camera, max_depth=5)
    println("Ray tracing finished")

    JuRenderBase.saveImage("cube.png", pixels, camera.w, camera.h)
end

renderCube()