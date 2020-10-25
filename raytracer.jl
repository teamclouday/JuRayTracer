# The ray tracer module
# reference: https://www.scratchapixel.com/lessons/3d-basic-rendering/ray-tracing-overview/ray-tracing-rendering-technique-overview

module JuRayTracer
export render

import LinearAlgebra
import Random

# include("./renderbase.jl")
import ..JuRenderBase

"""
Ray object\\
`origin`: original position of ray in world space\\
`direction`: unit vector of ray direction\\
`t_nearest`: nearest hit point t\\
`objectID`: nearest hit object ID\\
`faceID`: nearest hit object face ID\\
`depth`: recursion depth\\
`u`: ray intersection u\\
`v`: ray intersection v
"""
mutable struct Ray
    origin::Array{Float64}
    direction::Array{Float64}
    t_nearest::Float64
    objectID::Integer
    faceID::Integer
    depth::Integer
    u::Float64
    v::Float64
end

"""
Run fresnel formula for reflection energy
"""
function fresnel(I::Array{T}, N::Array{T}, ni::T)::T where T<:AbstractFloat
    @assert length(I) == length(N) == 3
    cosIN = clamp(sum(I .* N), -1.0, 1.0)
    R0 = (1.0 - ni) / (1.0 + ni)
    R0 = R0^2
    out = R0 + (1.0 - R0) * (1.0 - cosIN)^5
    return out
end

"""
Compute reflection direction of ray
"""
function ray_reflect(I::Array{T}, N::Array{T})::Array{T} where T<:AbstractFloat
    @assert length(I) == length(N) == 3
    out = I .- (2.0 * sum(I .* N)) .* N
    return out
end

"""
Compute refraction direction of ray from vacuum to medium
"""
function ray_refract(I::Array{T}, N::Array{T}, ni::T)::Array{T} where T<:AbstractFloat
    @assert length(I) == length(N) == 3
    cosIN = clamp(sum(I .* N), -1.0, 1.0)
    etai = 1.0
    etaj = ni
    n = copy(N)
    if cosIN < 0.0
        cosIN = -cosIN
    else
        etaj = 1.0
        etai = ni
        n .= -n
    end
    eta = etai / etaj
    cosON2 = 1.0 - eta^2 * (1.0 - cosIN^2)
    out = (eta * cosIN - sqrt(cosON2)) .* n
    if cosON2 >= 0.0
        out .= out .+ eta .* I
    end
    return out
end

"""
Test ray intersections and get necessary data
"""
function ray_intersect!(ray::Ray, world::JuRenderBase.World)
    for i in 1:length(world.objects)
        object = world.objects[i][1]
        transform = world.objects[i][2]
        for j in 1:length(object.faces)
            face = object.faces[j]
            # prepare vertices
            v1 = (transform * object.vertices[face[1][1]])[1:3]
            v2 = (transform * object.vertices[face[2][1]])[1:3]
            v3 = (transform * object.vertices[face[3][1]])[1:3]
            # compute triangle edges
            e1 = v2 .- v1 # edge 1
            e2 = v3 .- v1 # edge 2
            pvec = LinearAlgebra.cross(ray.direction, e2)
            det = sum(e1 .* pvec)
            # if determinant is negative or very small, ray miss
            if det <= 1e-8
                continue
            end
            invDet = 1.0 / det
            tvec = ray.origin .- v1
            u = sum(tvec .* pvec) * invDet
            if (u < 0.0) || (u > 1.0)
                continue
            end
            qvec = LinearAlgebra.cross(tvec, e1)
            v = sum(ray.direction .* qvec) * invDet
            if (v < 0.0) || (u+v > 1.0)
                continue
            end
            tnear = sum(e2 .* qvec) * invDet
            if tnear < ray.t_nearest && tnear > 1e-8
                ray.t_nearest = tnear
                ray.u = u
                ray.v = v
                ray.faceID = j
                ray.objectID = i
            end
        end
    end
end

"""
Cast ray into world and get pixel color
"""
function ray_cast(ray::Ray, world::JuRenderBase.World, camera::JuRenderBase.Camera, max_depth::Integer)::Array{AbstractFloat}
    if ray.depth > max_depth
        return copy(world.background)
    end
    hitColor = copy(world.background)
    ray.t_nearest = Inf64
    ray.faceID = 0
    ray.objectID = 0
    ray.u = 0.0
    ray.v = 0.0
    ray_intersect!(ray, world)
    # if ray hit
    if ray.objectID > 0 && ray.faceID > 0 && ray.t_nearest < Inf64
        hitPos = ray.origin .+ ray.direction .* ray.t_nearest
        object = world.objects[ray.objectID][1]
        @assert object.material !== nothing
        transform = world.objects[ray.objectID][2]
        v1 = (transform * object.vertices[object.faces[ray.faceID][1][1]])[1:3]
        v2 = (transform * object.vertices[object.faces[ray.faceID][2][1]])[1:3]
        v3 = (transform * object.vertices[object.faces[ray.faceID][3][1]])[1:3]
        e1 = v2 .- v1
        e2 = v3 .- v2
        hitColorSpec = [0.0, 0.0, 0.0]
        N = LinearAlgebra.normalize(LinearAlgebra.cross(e1, e2))
        if object.material.d > 0.0
            # compute phong model
            local orgShadow
            if sum(ray.direction .* N) < 0.0
                orgShadow = hitPos .- N .* 1e-8
            else
                orgShadow = hitPos .+ N .* 1e-8
            end
            lightAcc = [0.0, 0.0, 0.0]
            specAcc = [0.0, 0.0, 0.0]
            for i in 1:length(world.lights)
                light = world.lights[i]
                lightDir = light.pos .- hitPos
                lightDist2 = sum(lightDir .* lightDir)
                LinearAlgebra.normalize!(lightDir)
                LN = max(0.0, sum(lightDir .* N))
                shadowRay = Ray(orgShadow, lightDir, Inf64, 0, 0, 0, 0.0, 0.0)
                ray_intersect!(shadowRay, world)
                if !((shadowRay.objectID > 0 && shadowRay.faceID > 0 && shadowRay.faceID != ray.faceID && shadowRay.t_nearest < Inf64) && shadowRay.t_nearest^2 < lightDist2)
                    lightAcc .= lightAcc .+ light.color .* LN
                end
                dirRefl = LinearAlgebra.normalize(ray_reflect(-lightDir, N))
                specAcc .= specAcc .+ (max(0.0, -sum(dirRefl .* ray.direction)))^object.material.Ns .* light.color
            end
            hitColor .= lightAcc .* object.material.Kd
            hitColorSpec .= specAcc .* object.material.Ks .* object.material.d
        end
        if object.material.d < 1.0
            dirRefl = LinearAlgebra.normalize(ray_reflect(ray.direction, N))
            dirRefr = LinearAlgebra.normalize(ray_refract(ray.direction, N, object.material.Ni))
            local orgRefl, orgRefr
            if sum(dirRefl .* N) < 0.0
                orgRefl = hitPos .- N .* 1e-8
            else
                orgRefl = hitPos .+ N .* 1e-8
            end
            if sum(dirRefr .* N) < 0.0
                orgRefr = hitPos .- N .* 1e-8
            else
                orgRefr = hitPos .+ N .* 1e-8
            end
            kr = fresnel(ray.direction, N, object.material.Ni)
            rayRefl = Ray(orgRefl, dirRefl, Inf64, 0, 0, ray.depth+1, 0.0, 0.0)
            rayRefr = Ray(orgRefr, dirRefr, Inf64, 0, 0, ray.depth+1, 0.0, 0.0)
            colRefl = ray_cast(rayRefl, world, camera, max_depth)
            colRefr = ray_cast(rayRefr, world, camera, max_depth)
            hitColorSpec .= hitColorSpec .+ (1.0 - object.material.d) .* (colRefl .* kr .+ colRefr .* (1.0 - kr))
        end
        hitColor .= hitColor .+ hitColorSpec
    end
    clamp!(hitColor, 0.0, 1.0)
    return hitColor
end

"""
Ray trace based render function\\
`world`: world data\\
`camera`: perspective camera data\\
`max_depth`: max recursion depth
"""
function render(world::JuRenderBase.World, camera::JuRenderBase.Camera; max_depth::Integer=10)::Array{AbstractFloat}
    @assert max_depth > 0
    @assert camera.w > 0
    @assert camera.h > 0
    # generate framebuffer
    frame = zeros(3*camera.w*camera.h)
    # prepare perspective data
    posBottomLeft = [0.0, 0.0, 0.0]
    xVec = [0.0, 0.0, 0.0]
    yVec = [0.0, 0.0, 0.0]
    samples = [(m,n) for m in [-0.75,-0.25], n in [-0.75,-0.25]]
    JuRenderBase.ray_params!(camera, posBottomLeft, xVec, yVec)
    origin = copy(camera.pos)
    @sync Threads.@spawn for j in 1:camera.h, i in 1:camera.w
        pixel = zeros(3)
        for sample in samples
            # create ray
            rayTarget = posBottomLeft .+ (i-sample[1]) .* xVec .+ (j-sample[2]) .* yVec
            ray = Ray(origin, LinearAlgebra.normalize(rayTarget .- origin), Inf64, 0, 0, 0, 0.0, 0.0)
            pixel .= pixel .+ ray_cast(ray, world, camera, max_depth)
        end
        pixel .= pixel ./ length(samples)
        frame[3*camera.h*(i-1)+3*(camera.h-j)+1:3*camera.h*(i-1)+3*(camera.h-j)+3] .= pixel
    end
    return frame
end

end