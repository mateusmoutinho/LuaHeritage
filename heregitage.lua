
return (function ()

    local herigitage = {}
    herigitage.pairs =pairs
    herigitage.setmetatable = setmetatable
    herigitage.type = type
    herigitage.newMetaObject = function (props)
        if not props then
            props = {}
        end
        local selfobject = {}
        selfobject.public = props.public or {}
        selfobject.private = props.private or {}
        selfobject.meta_table =  props.meta_table or {}
        
        -- Factory function to create method setters
        local function createMethodSetter(target, extraAction)
            return function(method_name, callback)
                target[method_name] = function (...)
                    return callback(selfobject.public, selfobject.private, ...)
                end
                if extraAction then
                    extraAction()
                end
            end
        end
        
        -- Factory function to create extends functions
        local function createExtends(target, setter)
            return function(props)
                for k,v in herigitage.pairs(props) do
                    if herigitage.type(v) == "function" then
                        setter(k, v)
                    else
                        target[k] = v
                    end
                end
            end
        end

        selfobject.set_meta_method = createMethodSetter(selfobject.meta_table, function()
            herigitage.setmetatable(selfobject.public, selfobject.meta_table)
        end)
        
        selfobject.set_public_method = createMethodSetter(selfobject.public)
        
        selfobject.set_private_method = createMethodSetter(selfobject.private)
        
        selfobject.meta_extends = createExtends(selfobject.meta_table, selfobject.set_meta_method)
        
        selfobject.public_extends = createExtends(selfobject.public, selfobject.set_public_method)
        
        selfobject.private_extends = createExtends(selfobject.private, selfobject.set_private_method)

        return selfobject
    end


    return herigitage



end )()
