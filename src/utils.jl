function asset_path(ps...)
    return joinpath(Pkg.pkgdir(SDLProcessing) , "assets", ps...)
end