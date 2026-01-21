# TODO: create an asset library with a few basic geometrical figures (see examples assets)

# TODO: See Gloria.jl code and implement text diplaying...
# Additionally see how this (`finalizer(destroy!, self)`) works to
# handle objects with C contraparts...

# function Font(resources::Resources, filename::String; fontsize=12)
#     if filename in keys(resources)
#         @debug("resource already loaded: '$filename'")
#         return resources[filename]::Font
#     end

#     ptr = SDL.TTF_OpenFont(filename, fontsize)
#     self = Font(ptr, resources.render_ptr, filename, fontsize)
#     finalizer(destroy!, self)
#     resources[filename] = self
#     return self
# end