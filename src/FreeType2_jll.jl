module FreeType2_jll
using Pkg, Pkg.BinaryPlatforms, Pkg.Artifacts, Libdl
import Base: UUID

# Load Artifacts.toml file
artifacts_toml = joinpath(@__DIR__, "..", "Artifacts.toml")

# Extract all platforms
artifacts = Pkg.Artifacts.load_artifacts_toml(artifacts_toml; pkg_uuid=UUID("d7e528f0-a631-5988-bf34-fe36492bcfd7"))
platforms = [Pkg.Artifacts.unpack_platform(e, "FreeType2", artifacts_toml) for e in artifacts["FreeType2"]]

# Filter platforms based on what wrappers we've generated on-disk
platforms = filter(p -> isfile(joinpath(@__DIR__, "wrappers", triplet(p) * ".jl")), platforms)

# From the available options, choose the best platform
best_platform = select_platform(Dict(p => triplet(p) for p in platforms))

if best_platform === nothing
    error("Unable to load FreeType2; unsupported platform $(triplet(platform_key_abi()))")
end

# Load the appropriate wrapper
include(joinpath(@__DIR__, "wrappers", "$(best_platform).jl"))

end  # module FreeType2_jll
