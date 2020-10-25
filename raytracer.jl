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
    origin::Array{AbstractFloat}
    direction::Array{AbstractFloat}
    t_nearest::AbstractFloat
    objectID::Integer
    faceID::Integer
    depth::Integer
    u::AbstractFloat
    v::AbstractFloat
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
            face = object.faces[i]
            # prepare vertices
            v1 = (transform * object.vertices[face[1][1]])[1:3]
            v2 = (transform * object.vertices[face[2][1]])[1:3]
            v3 = (transform * object.vertices[face[3][1]])[1:3]
            # compute triangle edges
            e1 = v2 .- v1 # edge 1
            e2 = v3 .- v1 # edge 2
            pvec = LinearAlgebra.cross(ray.direction, e2)
            det = sum(e1 .* pvec)
            if det <= 0.0
                continue
            end
            tvec = ray.origin .- v1
            u = sum(tvec .* pvec)
            if u < 0.0 || u > det
                continue
            end
            qvec = LinearAlgebra.cross(tvec, e1)
            v = sum(ray.direction .* qvec)
            if v < 0.0 || u+v > det
                continue
            end
            invDet = 1.0 / det
            tnear = sum(e2 .* qvec) * invDet
            if tnear < ray.t_nearest && tnear > 0.00001
                u *= invDet
                v *= invDet
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
        N = LinearAlgebra.normalize(LinearAlgebra.cross(e1, e2))
        if object.material.d > 0.0
            # compute phong model
            local orgShadow
            if sum(ray.direction .* N) < 0.0
                orgShadow = hitPos .- N .* 0.00001
            else
                orgShadow = hitPos .+ N .* 0.00001
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
                if !((shadowRay.objectID > 0 && shadowRay.faceID > 0 && shadowRay.t_nearest < Inf64) && shadowRay.t_nearest^2 < lightDist2)
                    lightAcc .= lightAcc .+ light.color .* LN
                end
                dirRefl = ray_reflect(-lightDir, N)
                specAcc .= specAcc .+ (max(0.0, -sum(dirRefl .* ray.direction)))^object.material.Ns .* light.color
            end
            hitColor .= lightAcc .* object.material.Kd .+ specAcc .* object.material.Ks
            hitColor .= hitColor .* object.material.d
        end
        if object.material.d < 1.0
            dirRefl = LinearAlgebra.normalize(ray_reflect(ray.direction, N))
            dirRefr = LinearAlgebra.normalize(ray_refract(ray.direction, N, object.material.ni))
            local orgRefl, orgRefr
            if sum(dirRefl .* N) < 0.0
                orgRefl = hitPos .- N .* 0.00001
            else
                orgRefl = hitPos .+ N .* 0.00001
            end
            if sum(dirRefr .* N) < 0.0
                orgRefr = hitPos .- N .* 0.00001
            else
                orgRefr = hitPos .+ N .* 0.00001
            end
            kr = fresnel(ray.direction, N, object.material.ni)
            rayRefl = Ray(orgRefl, dirRefl, Inf64, 0, 0, ray.depth+1, 0.0, 0.0)
            rayRefr = Ray(orgRefr, dirRefr, Inf64, 0, 0, ray.depth+1, 0.0, 0.0)
            colRefl = ray_cast(rayRefl, world, camera, max_depth)
            colRefr = ray_cast(rayRefr, world, camera, max_depth)
            hitColor .= hitColor .+ (1.0 - object.material.d) .* (colRefl .* kr .+ colRefr .* (1.0 - kr))
        end
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
    scale = tan(camera.fov/2.0)
    ratio = float(camera.w) / float(camera.h)
    @sync Threads.@spawn for j in 1:camera.h, i in 1:camera.w
        # create ray
        x = (2.0 * (i-0.5) / camera.w - 1.0) * ratio * scale
        y = (1.0 - 2.0 * (j-0.5) / camera.h) * scale
        z = -1.0
        ray = Ray(copy(camera.pos), LinearAlgebra.normalize([x,y,z]), Inf64, 0, 0, 0, 0.0, 0.0)
        frame[3*camera.h*(i-1)+3*(j-1)+1:3*camera.h*(i-1)+3*(j-1)+3] .= ray_cast(ray, world, camera, max_depth)
    end
    return frame
end

end