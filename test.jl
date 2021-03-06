include("./renderbase.jl")
include("./raytracer.jl")
include("./tonemapper.jl")

import .JuRenderBase
import .JuRayTracer
import .JuToneMapper

function renderCube1()
    camera = JuRenderBase.Camera([10.0, 10.0, 10.0], [9.0, 9.0, 9.0], [0.0, 1.0, 0.0], 400, 400, deg2rad(60))
    println("Camera settled")
    objs = JuRenderBase.loadObjs("models/cube.obj")
    cube = objs[1]
    plane = objs[2]
    mat = JuRenderBase.mat_rotate([0.0, 1.0, 0.0], deg2rad(30))
    light1 = JuRenderBase.Light([5.0, 5.0, 0.0], [0.8, 0.8, 0.8])
    light2 = JuRenderBase.Light([0.0, 5.0, 5.0], [0.6, 0.6, 0.6])
    world = JuRenderBase.World([(cube,mat),(plane,JuRenderBase.mat_identity())], [light1], [0.0, 0.0, 0.0])
    println("World prepared")

    println("Ray tracing start")
    pixels::Array{Float64} = JuRayTracer.render(world, camera, max_depth=20)
    println("Ray tracing finished")

    JuRenderBase.saveImage("gallary/cube1.png", pixels, camera.w, camera.h)
end

function renderCube2()
    camera = JuRenderBase.Camera([10.0, 10.0, 10.0], [9.0, 9.0, 9.0], [0.0, 1.0, 0.0], 400, 400, deg2rad(60))
    println("Camera settled")
    objs = JuRenderBase.loadObjs("models/cube.obj")
    cube = objs[1]
    plane = objs[2]
    mat = JuRenderBase.mat_rotate([0.0, 1.0, 0.0], deg2rad(45))
    light1 = JuRenderBase.Light([5.0, 5.0, 0.0], [0.8, 0.8, 0.8])
    light2 = JuRenderBase.Light([0.0, 5.0, 5.0], [0.6, 0.6, 0.6])
    world = JuRenderBase.World([(cube,mat),(plane,JuRenderBase.mat_identity())], [light2], [0.0, 0.0, 0.0])
    println("World prepared")

    println("Ray tracing start")
    pixels::Array{Float64} = JuRayTracer.render(world, camera, max_depth=20)
    println("Ray tracing finished")

    JuRenderBase.saveImage("gallary/cube2.png", pixels, camera.w, camera.h)
end

function renderCube3()
    camera = JuRenderBase.Camera([10.0, 10.0, 10.0], [9.0, 9.0, 9.0], [0.0, 1.0, 0.0], 400, 400, deg2rad(60))
    println("Camera settled")
    objs = JuRenderBase.loadObjs("models/cube.obj")
    cube = objs[1]
    plane = objs[2]
    mat = JuRenderBase.mat_rotate([0.0, 1.0, 0.0], deg2rad(15))
    light1 = JuRenderBase.Light([5.0, 5.0, 0.0], [0.6, 0.6, 0.6])
    light2 = JuRenderBase.Light([0.0, 5.0, 5.0], [0.4, 0.4, 0.4])
    world = JuRenderBase.World([(cube,mat),(plane,JuRenderBase.mat_identity())], [light1,light2], [0.0, 0.0, 0.0])
    println("World prepared")

    println("Ray tracing start")
    pixels::Array{Float64} = JuRayTracer.render(world, camera, max_depth=20)
    println("Ray tracing finished")

    JuRenderBase.saveImage("gallary/cube3.png", pixels, camera.w, camera.h)
end

function renderCube4()
    camera = JuRenderBase.Camera([10.0, 10.0, 10.0], [9.0, 9.0, 9.0], [0.0, 1.0, 0.0], 400, 400, deg2rad(60))
    println("Camera settled")
    objs = JuRenderBase.loadObjs("models/cube.obj")
    cube = objs[1]
    plane = objs[2]
    mat = JuRenderBase.mat_rotate([0.0, 0.0, 1.0], deg2rad(30))
    light1 = JuRenderBase.Light([5.0, 5.0, 0.0], [0.6, 0.6, 0.6])
    light2 = JuRenderBase.Light([0.0, 5.0, 5.0], [0.4, 0.4, 0.4])
    world = JuRenderBase.World([(cube,mat),(plane,JuRenderBase.mat_identity())], [light1,light2], [0.0, 0.0, 0.0])
    println("World prepared")

    println("Ray tracing start")
    pixels::Array{Float64} = JuRayTracer.render(world, camera, max_depth=20)
    println("Ray tracing finished")

    JuRenderBase.saveImage("gallary/cube4.png", pixels, camera.w, camera.h)
end

function renderCube5()
    camera = JuRenderBase.Camera([10.0, 10.0, 10.0], [9.0, 9.0, 9.0], [0.0, 1.0, 0.0], 400, 400, deg2rad(60))
    println("Camera settled")
    objs = JuRenderBase.loadObjs("models/cube.obj")
    cube = objs[1]
    plane = objs[2]
    mat = JuRenderBase.mat_rotate([0.0, 1.0, 0.0], deg2rad(15))
    light1 = JuRenderBase.Light([5.0, 5.0, 0.0], [0.5, 0.5, 0.5])
    light2 = JuRenderBase.Light([0.0, 5.0, 5.0], [0.2, 0.2, 0.2])
    light3 = JuRenderBase.Light([-5.0, 5.0, -5.0], [0.4, 0.4, 0.4])
    world = JuRenderBase.World([(cube,mat),(plane,JuRenderBase.mat_identity())], [light1,light2,light3], [0.0, 0.0, 0.0])
    println("World prepared")

    println("Ray tracing start")
    pixels::Array{Float64} = JuRayTracer.render(world, camera, max_depth=20)
    println("Ray tracing finished")

    JuRenderBase.saveImage("gallary/cube5.png", pixels, camera.w, camera.h)
end

function renderCube6()
    camera = JuRenderBase.Camera([10.0, 10.0, 10.0], [9.0, 9.0, 9.0], [0.0, 1.0, 0.0], 400, 400, deg2rad(60))
    println("Camera settled")
    objs = JuRenderBase.loadObjs("models/cube.obj")
    cube = objs[1]
    plane = objs[2]
    mat = JuRenderBase.mat_rotate([0.0, 1.0, 0.0], deg2rad(15))
    mat2 = JuRenderBase.mat_translate([-4.0, 0.0, 0.0]) * JuRenderBase.mat_rotate([0.0, 1.0, 0.0], deg2rad(-30)) * JuRenderBase.mat_rotate([0.0, 0.0, -1.0], deg2rad(90))
    light = JuRenderBase.Light([5.0, 5.0, 0.0], [0.7, 0.7, 0.7])
    world = JuRenderBase.World([(cube,mat),(plane,JuRenderBase.mat_identity()),(plane,mat2)], [light], [0.0, 0.0, 0.0])
    println("World prepared")

    println("Ray tracing start")
    pixels::Array{Float64} = JuRayTracer.render(world, camera, max_depth=20)
    println("Ray tracing finished")

    JuRenderBase.saveImage("gallary/cube6.png", pixels, camera.w, camera.h)
end

function tonemap1()
    pixels, width, height = JuRenderBase.loadImage("gallary/memorial.jpg")
    mapped = JuToneMapper.map_reinhard_global(pixels, width, height, 3.0)
    JuRenderBase.saveImage("gallary/mapped1_1.png", mapped, width, height)
    mapped = JuToneMapper.map_reinhard_global(pixels, width, height, 1/3.0)
    JuRenderBase.saveImage("gallary/mapped1_2.png", mapped, width, height)
end

function montecarlo1()
    println("f(x) = sin(x)")
    f(x) = sin(x)
    samples = 10000000
    lower = 0.0
    upper = Float64(pi)
    p(x) = 1 / (upper - lower) # assume uniform distribution
    println("Samples: $samples\nLower: $lower\nUpper: $upper")
    result = JuRenderBase.monte_carlo_integration(f, p, samples, lower, upper)
    println("Integration is: $result")
end

function montecarlo2()
    println("f(x) = sin(x)*sin(x)")
    f(x) = sin(x)*sin(x)
    samples = 10000000
    lower = 0.0
    upper = Float64(pi)
    p(x) = 1 / (upper - lower) # assume uniform distribution
    println("Samples: $samples\nLower: $lower\nUpper: $upper")
    result = JuRenderBase.monte_carlo_integration(f, p, samples, lower, upper)
    println("Integration is: $result")
end



#renderCube1()
#renderCube2()
#renderCube3()
#renderCube4()
#renderCube5()
#renderCube6()

#tonemap1()

montecarlo1()
montecarlo2()