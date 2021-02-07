# The tone mapping module  

module JuToneMapper
export map_reinhard_global

"""
Reinhard Tone Mapper (global version)\\
processing steps:
1. Compute log average
2. Map average value to middle-gray given by `alpha`
3. Compress high luminances
"""
function map_reinhard_global(pixels::AbstractArray, width::Integer, height::Integer, α::AbstractFloat)::AbstractArray
    @assert length(pixels) == 3 * width * height
    result = copy(pixels)
    # compute log average
    δ = 0.0000000001 # avoid inf when using log function
    Lₐ = [0.0, 0.0, 0.0]
    for i in 1:(width*height)
        Lₐ .= Lₐ .+ log.(view(pixels, (3*i-2):(3*i)) .+ δ)
    end
    Lₐ .= exp.(Lₐ ./ (width * height))
    Lₐ = sum(Lₐ)
    # map average value to middle-gray given by α
    for i in 1:(width*height)
        result[(3*i-2):(3*i)] .= (α .* view(pixels, (3*i-2):(3*i))) ./ Lₐ
    end
    # compress high luminances
    for i in 1:(width*height)
        result[(3*i-2):(3*i)] .= view(result, (3*i-2):(3*i)) ./ (1.0 .+ view(result, (3*i-2):(3*i)))
    end
    clamp!(result, 0.0, 1.0)
    return result
end

"""
Reinhard Tone Mapper (global version)\\
processing steps:
1. Compute log average
2. Map average value to middle-gray given by `alpha`
3. Compress high luminances (by local average based on scale)
"""
function map_reinhard_local(pixels::AbstractArray, width::Integer, height::Integer, α::AbstractFloat; ϵ::AbstractFloat=0.05, ϕ::AbstractFloat=15.0)::AbstractArray
    @assert length(pixels) == 3 * width * height
    result = copy(pixels)
    # compute log average
    δ = 0.0000000001 # avoid inf when using log function
    Lₐ = [0.0, 0.0, 0.0]
    for i in 1:(width*height)
        Lₐ .= Lₐ .+ log.(view(pixels, (3*i-2):(3*i)) .+ δ)
    end
    Lₐ .= exp.(Lₐ ./ (width * height))
    Lₐ = sum(Lₐ)
    # map average value to middle-gray given by α
    for i in 1:(width*height)
        result[(3*i-2):(3*i)] .= (α .* view(pixels, (3*i-2):(3*i))) ./ Lₐ
    end
    # Compress high luminances (by local average based on scale)
    # reference: https://github.com/Vedant2311/Tone-Mapping-Library/blob/master/Reinhard.m
    α₁ = 1/(2*sqrt(2))
    α₂ = 1.6*α₁
    R₁ = zeros(3, width, height, 9)
    R₂ = zeros(3, width, height, 9)
    V₁ = zeros(3, width, height, 9)
    V₂ = zeros(3, width, height, 9)
    for x in 1:width
        for y in 1:height
            for s in 1:9
                sₛ = 1.6 ^ (s - 1.0)
                R₁[:,x,y,s] = (1/(pi*(α₁*sₛ)^2)) * exp(-(x^2+y^2)/(α₁+sₛ)^2)
                R₂[:,x,y,s] = (1/(pi*(α₂*sₛ)^2)) * exp(-(x^2+y^2)/(α₂+sₛ)^2)
            end
        end
    end

end


end