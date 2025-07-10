
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
        
        selfobject.set_meta_method = createMethodSetter(selfobject.meta_table, function()
            herigitage.setmetatable(selfobject.public, selfobject.meta_table)
        end)
        
        selfobject.set_public_method = createMethodSetter(selfobject.public)
        
        selfobject.set_private_method = createMethodSetter(selfobject.private)
        
        -- Props extends functions - basic property assignment without function checking
        selfobject.public_props_extends = function(props)
            for k,v in herigitage.pairs(props) do
                selfobject.public[k] = v
            end
        end
        
        selfobject.private_props_extends = function(props)
            for k,v in herigitage.pairs(props) do
                selfobject.private[k] = v
            end
        end
        
        selfobject.meta_props_extends = function(props)
            for k,v in herigitage.pairs(props) do
                selfobject.meta_table[k] = v
            end
        end
        
        -- Method extends functions - treat all props as methods
        selfobject.public_method_extends = function(props)
            for k,v in herigitage.pairs(props) do
                selfobject.set_public_method(k, v)
            end
        end
        
        selfobject.private_method_extends = function(props)
            for k,v in herigitage.pairs(props) do
                selfobject.set_private_method(k, v)
            end
        end
        
        selfobject.meta_method_extends = function(props)
            for k,v in herigitage.pairs(props) do
                selfobject.set_meta_method(k, v)
            end
        end

        return selfobject
    end


    return herigitage



end )()
