# The basic module that defines a static scene and helper functions

module JuRenderBase
export Camera, Object, Light, World
export loadObjs, saveImage
export mat_identity, mat_rotate, mat_scale, mat_translate, mat_view, mat_perspective

import Images
import LinearAlgebra

"""
Camera data\\
`pos`: camera position in global world\\
`center`: camera center\\
`up`: UP vector\\
`w`: width of output image\\
`h`: height of output image\\
`fov`: field of view (angle in radians)\\
`zNear`: near distance\\
`zFar`: far distance
"""
mutable struct Camera
    pos::Array{AbstractFloat}
    center::Array{AbstractFloat}
    up::Array{AbstractFloat}
    w::Integer
    h::Integer
    fov::AbstractFloat
    zNear::AbstractFloat
    zFar::AbstractFloat
end

"""
Material data\\
`Ka`: ambient color\\
`Kd`: diffuse color\\
`Ks`: specular color\\
`Ke`: emissive color\\
`Ns`: specular exponent\\
`Ni`: optical density\\
`d`: transparency
"""
mutable struct Material
    Ka::Array{AbstractFloat}
    Kd::Array{AbstractFloat}
    Ks::Array{AbstractFloat}
    Ke::Array{AbstractFloat}
    Ns::AbstractFloat
    Ni::AbstractFloat
    d::AbstractFloat
end

"""
Object data\\
`vertices`: all vertices in the object\\
`normals`: normal vectors in the object\\
`UVs`: UV coordinates for the object\\
`faces`: each face/triangle has 3 pairs of (vertice, normal, UV)\\
`material`: material data for the object
"""
mutable struct Object
    vertices::Array{Array{AbstractFloat}}
    normals::Array{Array{AbstractFloat}}
    UVs::Array{Array{AbstractFloat}}
    faces::Array{Array{Array{Integer}}}
    material::Union{Material,Nothing}
end

"""
Point light source data\\
`pos`: position of light source\\
`color`: color of light source
"""
mutable struct Light
    pos::Array{AbstractFloat}
    color::Array{AbstractFloat}
end

"""
World data\\
`objects`: all objects and corresponding transforms in the world\\
`lights`: all light sources in the world\\
`background`: background color
"""
mutable struct World
    objects::Array{Tuple{Object,Array{AbstractFloat}}}
    lights::Array{Light}
    background::Array{AbstractFloat}
end

"""
load objects data from file
"""
function loadObjs(filename::String)::Array{Object}
    @assert isfile(filename)
    @assert filename[findlast(isequal('.'),filename):end] == ".obj"
    objs::Array{Object} = []
    mats::Dict{String,Material} = Dict()
    lines = readlines(filename)
    accV = 0
    accVt = 0
    accVn = 0
    for line in lines
        line_arr = split(line)
        if length(line_arr) <= 0
            continue
        end
        if line_arr[1] == "#"
            continue
        elseif line_arr[1] == "mtllib"
            @assert length(line_arr) > 1
            mats = loadMaterials(String(line_arr[2]))
        elseif line_arr[1] == "o"
            if length(objs) > 0
                lastObj = objs[end]
                accV += length(lastObj.vertices)
                accVt += length(lastObj.UVs)
                accVn += length(lastObj.normals)
            end
            push!(objs, Object([], [], [], [], nothing))
        elseif line_arr[1] == "v"
            @assert length(line_arr) >= 4
            push!(objs[end].vertices, [parse(Float64, line_arr[2]),parse(Float64, line_arr[3]),parse(Float64, line_arr[4]),1.0])
        elseif line_arr[1] == "vt"
            @assert length(line_arr) > 1
            if length(line_arr) == 2
                push!(objs[end].UVs, [parse(Float64, line_arr[2]),0.0,0.0])
            elseif length(line_arr) == 3
                push!(objs[end].UVs, [parse(Float64, line_arr[2]),parse(Float64, line_arr[3]),0.0])
            elseif length(line_arr) >= 4
                push!(objs[end].UVs, [parse(Float64, line_arr[2]),parse(Float64, line_arr[3]),parse(Float64, line_arr[4])])
            end
        elseif line_arr[1] == "vn"
            @assert length(line_arr) >= 4
            push!(objs[end].normals, [parse(Float64, line_arr[2]),parse(Float64, line_arr[3]),parse(Float64, line_arr[4])])
        elseif line_arr[1] == "f"
            @assert length(line_arr) >= 4
            face::Array{Array{Integer}} = []
            for k in 2:4
                face_arr = split(line_arr[k], '/')
                face_arr[face_arr .== ""] .= "0"
                face_arr = map(x->parse(Int32, x), face_arr)
                face_arr[1] -= accV
                face_arr[2] -= accVt
                face_arr[3] -= accVn
                clamp!(face_arr, 0, Inf)
                push!(face, face_arr)
            end
            push!(objs[end].faces, face)
        elseif line_arr[1] == "usemtl"
            @assert length(line_arr) > 1
            @assert line_arr[2] in keys(mats)
            objs[end].material = mats[line_arr[2]]
        end
    end
    return objs
end

"""
load material data from file
"""
function loadMaterials(filename::String)::Dict{String,Material}
    @assert isfile(filename)
    @assert filename[findlast(isequal('.'),filename):end] == ".mtl"
    mats::Dict{String,Material} = Dict()
    lines = readlines(filename)
    matName = ""
    for line in lines
        line_arr = split(line)
        if length(line_arr) <= 0
            continue
        end
        if line_arr[1] == "#"
            continue
        elseif line_arr[1] == "newmtl"
            @assert length(line_arr) > 1
            @assert !(line_arr[2] in keys(mats))
            matName = line_arr[2]
            mats[matName] = Material(zeros(3), zeros(3), zeros(3), zeros(3), 0.0, 1.0, 1.0)
        elseif line_arr[1] == "Ns"
            @assert length(line_arr) > 1
            @assert matName in keys(mats)
            mats[matName].Ns = parse(Float64, line_arr[2])
        elseif line_arr[1] == "Ni"
            @assert length(line_arr) > 1
            @assert matName in keys(mats)
            mats[matName].Ni = parse(Float64, line_arr[2])
        elseif line_arr[1] == "d"
            @assert length(line_arr) > 1
            @assert matName in keys(mats)
            mats[matName].d = parse(Float64, line_arr[2])
        elseif line_arr[1] == "Ka"
            @assert length(line_arr) >= 4
            @assert matName in keys(mats)
            mats[matName].Ka = [parse(Float64, line_arr[2]), parse(Float64, line_arr[3]), parse(Float64, line_arr[4])]
        elseif line_arr[1] == "Kd"
            @assert length(line_arr) >= 4
            @assert matName in keys(mats)
            mats[matName].Kd = [parse(Float64, line_arr[2]), parse(Float64, line_arr[3]), parse(Float64, line_arr[4])]
        elseif line_arr[1] == "Ks"
            @assert length(line_arr) >= 4
            @assert matName in keys(mats)
            mats[matName].Ks = [parse(Float64, line_arr[2]), parse(Float64, line_arr[3]), parse(Float64, line_arr[4])]
        elseif line_arr[1] == "Ke"
            @assert length(line_arr) >= 4
            @assert matName in keys(mats)
            mats[matName].Ke = [parse(Float64, line_arr[2]), parse(Float64, line_arr[3]), parse(Float64, line_arr[4])]
        end
    end
    return mats
end

"""
Save RGB pixels to image file
"""
function saveImage(filename::String, pixels::Array{T}, width::Integer, height::Integer) where T<:AbstractFloat
    @assert width > 0
    @assert height > 0
    @assert length(pixels) >= 3*width*height
    pixels = pixels[1:3*width*height]
    Images.save(filename, Images.colorview(Images.RGB, reshape(pixels, (3, height, width))))
end

"""
Generate identity matrix
"""
function mat_identity()::Array{AbstractFloat}
    mat = [1.0 0.0 0.0 0.0;
           0.0 1.0 0.0 0.0;
           0.0 0.0 1.0 0.0;
           0.0 0.0 0.0 1.0]
    return mat
end

"""
Generate scale matrix\\
`scale`: scale value
"""
function mat_scale(scale::T)::Array{T} where T<:AbstractFloat
    mat = mat_identity()
    for i in 1:3
        mat[i, i] = scale
    end
    return mat
end

"""
Generate translation matrix\\
`delta`: delta vector of translation
"""
function mat_translate(delta::Array{T})::Array{T} where T<:AbstractFloat
    @assert length(delta) == 3
    mat = mat_identity()
    for i in 1:3
        mat[i, 4] = delta[i]
    end
    return mat
end

# reference: https://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToMatrix/index.htm
"""
Generate rotation matrix (quaternion)\\
`axis`: axis vector of rotation\\
`angle`: angle in radians
"""
function mat_rotate(axis::Array{T}, angle::T)::Array{T} where T<:AbstractFloat
    @assert length(axis) == 3
    x = axis[1] * sin(angle / 2.0)
    y = axis[2] * sin(angle / 2.0)
    z = axis[3] * sin(angle / 2.0)
    w = cos(angle / 2.0)
    mat = [(1-2*y^2-2*z^2) (2*x*y-2*z*w)   (2*x*z+2*y*w)   0.0;
           (2*x*y+2*z*w)   (1-2*x^2-2*z^2) (2*y*z-2*x*w)   0.0;
           (2*x*z-2*y*w)   (2*y*z+2*x*w)   (1-2*x^2-2*y^2) 0.0;
           0.0             0.0             0.0             1.0]
    return mat
end

# reference: glm lookAt
"""
Generate camera view matrix
"""
function mat_view(camera::Camera)::Array{AbstractFloat}
    f = LinearAlgebra.normalize(camera.center .- camera.pos)
    u = LinearAlgebra.normalize(camera.up)
    s = LinearAlgebra.normalize(LinearAlgebra.cross(f, u))
    u = LinearAlgebra.cross(s, f)
    mat = mat_identity()
    mat[1, 1] = s[1]
    mat[2, 1] = s[2]
    mat[3, 1] = s[3]
    mat[1, 2] = u[1]
    mat[2, 2] = u[2]
    mat[3, 2] = u[3]
    mat[1, 3] = -f[1]
    mat[2, 3] = -f[2]
    mat[3, 3] = -f[3]
    mat[4, 1] = -sum(s .* camera.pos)
    mat[4, 2] = -sum(u .* camera.pos)
    mat[4, 3] = sum(f .* camera.pos)
    return mat'
end

# reference: glm perspective
"""
Generate perspective projection matrix
"""
function mat_perspective(camera::Camera)::Array{AbstractFloat}
    range = tan(camera.fov/2.0) * camera.zNear
    ratio = float(camera.w) / float(camera.h)
    left = -range * ratio
    right = range * ratio
    bottom = -range
    top = range
    mat = [(2.0*camera.zNear/(right-left)) 0.0 0.0 0.0;
           0.0 (2.0*camera.zNear/(top-bottom)) 0.0 0.0;
           0.0 0.0 -((camera.zFar+camera.zNear)/(camera.zFar-camera.zNear)) -1.0;
           0.0 0.0 -(2.0*camera.zFar*camera.zNear/(camera.zFar-camera.zNear)) 0.0]
    return mat'
end

end