# TODO: Add priority levels to callbacks?
# TODO: Check ObaServers callbacks engine

const ONCONFIG_CALLBACKS = Function[]
onconfig!(f::Function) = push!(ONCONFIG_CALLBACKS, f)

const ONSETUP_CALLBACKS = Function[]
onsetup!(f::Function) = push!(ONSETUP_CALLBACKS, f)

const ONDRAW_CALLBACKS = Function[]
ondraw!(f::Function) = push!(ONDRAW_CALLBACKS, f)

const ONFINALLY_CALLBACKS = Function[]
onfinally!(f::Function) = push!(ONFINALLY_CALLBACKS, f)

const ONEVENT_CALLBACKS = Function[]
onevent!(f::Function) = push!(ONEVENT_CALLBACKS, f)

const ONINFO_CALLBACKS = Function[]
oninfo!(f::Function) = push!(ONINFO_CALLBACKS, f)

const UPTHREAD_CALLBACKS = Function[]
onthread!(f::Function) = push!(UPTHREAD_CALLBACKS, f)

